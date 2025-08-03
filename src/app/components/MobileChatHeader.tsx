'use client';

import { ChevronLeft } from 'lucide-react';

interface MobileChatHeaderProps {
  onBackClick: () => void;
}

export const MobileChatHeader = ({ onBackClick }: MobileChatHeaderProps) => {
  return (
    <button
      onClick={onBackClick}
      className="mr-3 rounded hover:bg-gray-100 flex items-center justify-center"
      aria-label="Back to channel list"
    >
      <ChevronLeft size={30} />
    </button>
  );
};