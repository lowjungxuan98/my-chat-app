'use client';

import {
  Channel,
  ChannelHeader,
  MessageInput,
  MessageList,
  Thread,
  Window,
} from 'stream-chat-react';
import { MobileChatHeader } from './MobileChatHeader';

interface ChatAreaProps {
  isMobile: boolean;
  onBackToChannelList: () => void;
}

export const ChatArea = ({ isMobile, onBackToChannelList }: ChatAreaProps) => {
  return (
    <div className={`${isMobile ? 'w-full' : 'flex-1'}`}>
      <Channel>
        <Window>
          <div className="flex items-center p-4 border-b border-gray-200">
            {isMobile && (
              <MobileChatHeader onBackClick={onBackToChannelList} />
            )}
            <ChannelHeader />
          </div>
          <MessageList />
          <MessageInput />
        </Window>
        <Thread />
      </Channel>
    </div>
  );
};