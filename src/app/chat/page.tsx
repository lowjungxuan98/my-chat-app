'use client';

import { Chat } from 'stream-chat-react';
import { useEffect, useState } from 'react';
import { ChannelSort, StreamChat } from 'stream-chat';
import { useRouter } from 'next/navigation';
import { useAuth } from '../context/AuthContext';
import { useMobile } from '../context/MobileContext';
import { LoadingSpinner } from '../components/LoadingSpinner';
import { ChannelSidebar } from '../components/ChannelSidebar';
import { ChatArea } from '../components/ChatArea';

const apiKey = process.env.NEXT_PUBLIC_STREAM_API_KEY!;

export default function ChatPage() {
  const [client, setClient] = useState<StreamChat | null>(null);
  const [streamUser, setStreamUser] = useState<any>(null);
  const [filters, setFilters] = useState<any>(null);
  const [showChannelList, setShowChannelList] = useState(true);
  const { user, loading } = useAuth();
  const router = useRouter();
  const sort: ChannelSort = { last_message_at: -1 };
  const { isMobile } = useMobile();

  // Handle mobile view - show channel list by default on mobile, hide when channel selected
  useEffect(() => {
    if (isMobile) {
      setShowChannelList(true);
    }
  }, [isMobile]);

  useEffect(() => {
    if (!user && !loading) {
      router.push('/');
      return;
    }

    if (!user) return;

    const initChat = async () => {
      try {
        const chatClient = StreamChat.getInstance(apiKey);

        const response = await fetch('/api/token', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
        });

        if (!response.ok) {
          throw new Error('Failed to get token');
        }

        const { token, user: streamUserData } = await response.json();

        await chatClient.connectUser(streamUserData, token);
        setClient(chatClient);
        setStreamUser(streamUserData);
        console.log('Setting filters with user ID:', streamUserData.id);
        setFilters({ type: 'messaging', members: { $in: [streamUserData.id] } });
      } catch (error) {
        console.error('Chat initialization error:', error);
        router.push('/');
      }
    };

    initChat();

    return () => {
      client?.disconnectUser();
    };
  }, [user, loading, router]);

  if (loading) {
    return <LoadingSpinner message="Loading..." />;
  }

  if (!user) {
    return <LoadingSpinner message="Redirecting to login..." />;
  }

  if (!client || !streamUser || !filters) {
    return <LoadingSpinner message="Loading chat..." />;
  }

  const handleChannelSelect = () => {
    if (isMobile) {
      setShowChannelList(false);
    }
  };

  const handleBackToChannelList = () => {
    setShowChannelList(true);
  };

  return (
    <div className="flex h-screen">
      <Chat client={client}>
        {/* Channel List - Show/Hide based on mobile state */}
        {(!isMobile || showChannelList) && (
          <ChannelSidebar
            filters={filters}
            sort={sort}
            isMobile={isMobile}
            onChannelSelect={handleChannelSelect}
          />
        )}
        
        {/* Chat Area - Show when not mobile or when channel list is hidden */}
        {(!isMobile || !showChannelList) && (
          <ChatArea
            isMobile={isMobile}
            onBackToChannelList={handleBackToChannelList}
          />
        )}
      </Chat>
    </div>
  );
} 