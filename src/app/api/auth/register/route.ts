import { NextRequest, NextResponse } from 'next/server';
import { createHash } from 'crypto';
import { prisma } from '../../../../server/lib/prisma';

function hashPassword(password: string): string {
  return createHash('sha256').update(password).digest('hex');
}

function generateUserId(email: string): string {
  return `user_${createHash('md5').update(email).digest('hex').substring(0, 8)}`;
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email, password, name } = body;

    // Validation
    if (!email || !password) {
      return NextResponse.json(
        { error: 'Email and password are required' },
        { status: 400 }
      );
    }

    if (password.length < 6) {
      return NextResponse.json(
        { error: 'Password must be at least 6 characters long' },
        { status: 400 }
      );
    }

    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return NextResponse.json(
        { error: 'User with this email already exists' },
        { status: 409 }
      );
    }

    // Create new user
    const hashedPassword = hashPassword(password);
    const userId = generateUserId(email);

    const user = await prisma.user.create({
      data: {
        userId,
        email,
        password: hashedPassword,
        name: name || email.split('@')[0], // Use email prefix as default name
      },
    });

    // Return user data without password
    const { password: _password, ...userWithoutPassword } = user;

    const response = NextResponse.json({
      message: 'User created successfully',
      user: userWithoutPassword,
    });

    // Set session cookie
    response.cookies.set('userId', userId, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 30 * 24 * 60 * 60, // 30 days
    });

    return response;
  } catch (error) {
    console.error('Registration error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}