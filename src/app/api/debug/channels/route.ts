import { NextRequest, NextResponse } from 'next/server';
import { StreamChat } from 'stream-chat';
import { prisma } from '../../../../server/lib/prisma';

const api_key = process.env.NEXT_PUBLIC_STREAM_API_KEY!;
const api_secret = process.env.STREAM_API_SECRET!;
const serverClient = StreamChat.getInstance(api_key, api_secret);

export async function GET(request: NextRequest) {
  try {
    // Get user from cookie
    const userId = request.cookies.get('userId')?.value;

    if (!userId) {
      return NextResponse.json(
        { error: 'Not authenticated' },
        { status: 401 }
      );
    }

    // Get user from database
    const user = await prisma.user.findUnique({
      where: { userId },
    });

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    // Get channels from database
    const dbChannels = await prisma.channel.findMany({
      include: {
        members: {
          where: { userId },
        },
      },
    });

    // Get channels from Stream Chat
    const streamChannels = await serverClient.queryChannels({
      type: 'messaging',
      members: { $in: [userId] },
    });

    return NextResponse.json({
      userId,
      userName: user.name || user.email.split('@')[0],
      databaseChannels: dbChannels,
      streamChannels: streamChannels.map(channel => ({
        cid: channel.cid,
        id: channel.id,
        members: Object.keys(channel.state.members),
        memberCount: Object.keys(channel.state.members).length,
      })),
      filters: { type: 'messaging', members: { $in: [userId] } },
    });
  } catch (error: any) {
    console.error('Debug channels error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}