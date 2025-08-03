'use client';

import { useEffect, useState } from 'react';
import { StreamChat } from 'stream-chat';
import { Chat, Streami18n } from 'stream-chat-react';

const apiKey = process.env.NEXT_PUBLIC_STREAM_API_KEY!;
const userId = 'sample-user'; // replace dynamically
const userName = 'Sample User'; // replace dynamically

const client = StreamChat.getInstance(apiKey);

// Custom i18n instance (optional, default to English)
const i18nInstance = new Streami18n({ language: 'en' });

export default function StreamChatProvider({ children }: { children: React.ReactNode }) {
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    const setupChat = async () => {
      try {
        const response = await fetch('/api/token', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ userId, userName }),
        });
        const data = await response.json();

        if (data.token) {
          await client.connectUser({ id: userId, name: userName }, data.token);
          setIsConnected(true);
        } else {
          console.error('Token fetch error:', data.error);
        }
      } catch (error) {
        console.error('Chat setup error:', error);
      }
    };

    setupChat();

    return () => {
      client.disconnectUser(); // clean-up on unmount
    };
  }, []);

  if (!isConnected) {
    return <div>Connecting to chat...</div>;
  }

  return (
    <Chat client={client} i18nInstance={i18nInstance}>
      {children}
    </Chat>
  );
} 