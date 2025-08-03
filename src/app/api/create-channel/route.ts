import { NextResponse } from 'next/server';
import { StreamChat } from 'stream-chat';
import { prisma } from '../../../server/lib/prisma';
import crypto from 'crypto';

const api_key = process.env.NEXT_PUBLIC_STREAM_API_KEY!;
const api_secret = process.env.STREAM_API_SECRET!;
const serverClient = StreamChat.getInstance(api_key, api_secret);

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { 
      channelId, 
      userIds, 
      channelType = 'messaging', 
      channelName = channelId || 'General'
    } = body;

    // Validate required fields
    if (!channelId || !userIds || !Array.isArray(userIds) || userIds.length === 0) {
      return NextResponse.json(
        { error: 'channelId and userIds (array) are required' },
        { status: 400 }
      );
    }

    // Check if channel already exists in database
    const existingChannel = await prisma.channel.findUnique({
      where: { channelId },
      include: {
        members: true
      }
    });

    if (existingChannel) {
      // Channel exists - check if user is already a member
      const isAlreadyMember = existingChannel.members.some(member => 
        userIds.includes(member.userId)
      );

      if (isAlreadyMember) {
        return NextResponse.json({
          success: true,
          message: 'You are already a member of this channel',
          channelId: channelId,
          streamCid: `messaging:${channelId}`,
          dbId: existingChannel.id,
          action: 'already_member'
        });
      }

      // User is not a member - add them to the existing channel
      console.log('Adding users to existing channel:', userIds);
      
      // Ensure users exist in Stream Chat first
      for (const uid of userIds) {
        const user = await prisma.user.findUnique({ where: { userId: uid } });
        if (user) {
          const userName = user.name || user.email.split('@')[0];
          const userImage = user.image || 'https://picsum.photos/200';
          await serverClient.upsertUser({
            id: uid,
            name: userName,
            image: userImage,
          });
        }
      }
      
      // Add to Stream Chat channel
      const streamChannel = serverClient.channel('messaging', channelId);
      await streamChannel.addMembers(userIds);
      
      // Add to database
      await prisma.channelMember.createMany({
        data: userIds.map(uid => ({
          channelId: channelId,
          userId: uid
        })),
        skipDuplicates: true
      });

      return NextResponse.json({
        success: true,
        message: 'Successfully joined the existing channel',
        channelId: channelId,
        streamCid: `messaging:${channelId}`,
        dbId: existingChannel.id,
        action: 'joined_existing'
      });
    }

    // Verify all users exist in database
    const users = await prisma.user.findMany({
      where: { userId: { in: userIds } }
    });

    if (users.length !== userIds.length) {
      const foundUserIds = users.map(u => u.userId);
      const missingUserIds = userIds.filter(id => !foundUserIds.includes(id));
      return NextResponse.json(
        { error: `Users not found: ${missingUserIds.join(', ')}` },
        { status: 404 }
      );
    }

    // 1. Ensure all users exist in Stream Chat first
    console.log('Creating channel with userIds:', userIds);
    for (const uid of userIds) {
      const user = users.find(u => u.userId === uid);
      const userName = user?.name || user?.email?.split('@')[0] || uid;
      const userImage = user?.image || 'https://picsum.photos/200';
      await serverClient.upsertUser({
        id: uid,
        name: userName,
        image: userImage,
      });
    }

    // 2. Create channel in Stream
    const channel = serverClient.channel(channelType, channelId, {
      members: userIds,
      created_by_id: userIds[0], // First user in the list is the creator
    });
    await channel.create();
    console.log('Channel created in Stream:', channel.cid);

    // 4. Insert into Prisma
    const dbChan = await prisma.channel.create({
      data: {
        channelId: channelId,
        type: channelType,
        name: channelName,
        members: {
          create: userIds.map((uid: string) => ({
            user: { connect: { userId: uid } },
          })),
        },
      },
    });

    // send back the result
    return NextResponse.json({ 
      success: true,
      streamCid: channel.cid, 
      dbId: dbChan.id,
      channelId: channelId,
      message: 'Channel created successfully'
    });
  } catch (error: any) {
    console.error('Create channel error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
} 