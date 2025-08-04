'use client';

import { ChannelPreviewUIComponentProps } from 'stream-chat-react';
import { Hash, Users } from 'lucide-react';

interface CustomChannelPreviewProps extends ChannelPreviewUIComponentProps {
  onChannelSelect?: () => void;
}

export const CustomChannelPreview = ({ 
  channel, 
  displayTitle, 
  lastMessage, 
  latestMessagePreview, 
  unread, 
  setActiveChannel,
  onChannelSelect
}: CustomChannelPreviewProps) => {
  const handleChannelSelect = () => {
    setActiveChannel?.(channel);
    onChannelSelect?.();
  };
  
  // Determine if it's a group channel based on channel type or members
  const isGroupChannel = channel.data?.type === 'messaging' && Object.keys(channel.state.members || {}).length > 2;

  return (
    <div 
      className="flex items-center p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100"
      onClick={handleChannelSelect}
    >
      <div className="flex-shrink-0 mr-3">
        {isGroupChannel ? (
          <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
            <Users className="w-4 h-4 text-blue-600" />
          </div>
        ) : (
          <div className="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center">
            <Hash className="w-4 h-4 text-gray-600" />
          </div>
        )}
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-medium text-gray-900 truncate">
            {displayTitle || channel.id?.toUpperCase() || 'General'}
          </h3>
          {lastMessage?.created_at && (
            <span className="text-xs text-gray-500">
              {new Date(lastMessage.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
            </span>
          )}
        </div>
        <div className="flex items-center justify-between mt-1">
          <div className="text-sm text-gray-600 truncate">
            {latestMessagePreview || 'No messages yet'}
          </div>
          {unread && unread > 0 && (
            <span className="inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white bg-blue-600 rounded-full">
              {unread}
            </span>
          )}
        </div>
      </div>
    </div>
  );
};