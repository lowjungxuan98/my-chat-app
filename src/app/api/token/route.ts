import { NextRequest, NextResponse } from 'next/server';
import { StreamChat } from 'stream-chat';
import { prisma } from '../../../server/lib/prisma';

const api_key = process.env.NEXT_PUBLIC_STREAM_API_KEY!;
const api_secret = process.env.STREAM_API_SECRET!;

// Initialize Stream server-side client
const serverClient = StreamChat.getInstance(api_key, api_secret);

export async function POST(request: NextRequest) {
  try {
    // Get user from cookie instead of request body
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

    // Update last seen
    await prisma.user.update({
      where: { userId },
      data: { lastSeenAt: new Date() },
    });

    const userName = user.name || user.email.split('@')[0];

    // Push the user to Stream
    await serverClient.upsertUser({
      id: userId,
      name: userName,
      image: user.image || undefined,
      role: 'user',
    });

    // Generate the token
    const token = serverClient.createToken(userId);
    
    return NextResponse.json({ 
      token,
      user: {
        id: userId,
        name: userName,
        image: user.image || undefined,
      }
    });
  } catch (error: unknown) {
    console.error('Token generation error:', error);
    return NextResponse.json({ error: error instanceof Error ? error.message : 'Unknown error' }, { status: 500 });
  }
} 