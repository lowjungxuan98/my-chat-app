'use client';

import { ChannelList } from 'stream-chat-react';
import { ChannelSort, ChannelFilters } from 'stream-chat';
import { CustomChannelPreview } from './CustomChannelPreview';

interface ChannelSidebarProps {
  filters: ChannelFilters;
  sort: ChannelSort;
  isMobile: boolean;
  onChannelSelect: () => void;
}

export const ChannelSidebar = ({ 
  filters, 
  sort, 
  isMobile, 
  onChannelSelect 
}: ChannelSidebarProps) => {
  return (
    <div className={`${isMobile ? 'w-full' : 'w-80'} border-r border-gray-200`}>
      <ChannelList
        filters={filters}
        sort={sort}
        showChannelSearch={true}
        Preview={(props) => (
          <CustomChannelPreview 
            {...props} 
            onChannelSelect={onChannelSelect}
          />
        )}
      />
    </div>
  );
};