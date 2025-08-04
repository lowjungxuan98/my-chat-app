'use client';

import { useState } from 'react';
import { useAuth } from '../context/AuthContext';

export default function CreateChannelButton() {
  const [isCreating, setIsCreating] = useState(false);
  const [message, setMessage] = useState('');
  const [channelName, setChannelName] = useState('');
  const { user } = useAuth();

  const createTestChannel = async () => {
    if (!user) {
      setMessage('You must be logged in to create a channel.');
      return;
    }

    if (!channelName.trim()) {
      setMessage('Please enter a channel name.');
      return;
    }

    setIsCreating(true);
    setMessage('');

    try {
      const channelId = channelName.toLowerCase().replace(/[^a-z0-9]/g, '-');
      console.log('Creating channel:', channelId, 'for user:', user.userId);
      
      const response = await fetch('/api/create-channel', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          channelId: channelId,
          userIds: [user.userId],
        }),
      });

      const data = await response.json();

      if (response.ok) {
        setMessage('Channel created successfully! Refresh the page to see it.');
      } else {
        setMessage(`Error: ${data.error}`);
      }
    } catch (_error) {
      setMessage('Failed to create channel. Please try again.');
    } finally {
      setIsCreating(false);
    }
  };

  if (!user) {
    return null; // Don't show the button if user is not authenticated
  }

  return (
    <div className="p-4 border border-gray-200 dark:border-gray-700 rounded-lg bg-gray-50 dark:bg-gray-700">
      <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-white">Create New Channel</h3>
      
      <div className="space-y-3">
        <input
          type="text"
          value={channelName}
          onChange={(e) => setChannelName(e.target.value)}
          placeholder="Enter channel name (e.g., Random, Help, etc.)"
          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        />
        
        <button
          onClick={createTestChannel}
          disabled={isCreating || !channelName.trim()}
          className="w-full px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:opacity-50 transition-colors"
        >
          {isCreating ? 'Creating...' : 'Create Channel'}
        </button>
      </div>
      
      {message && (
        <p className={`mt-2 text-sm ${message.includes('Error') ? 'text-red-600 dark:text-red-400' : 'text-green-600 dark:text-green-400'}`}>
          {message}
        </p>
      )}
      
      <div className="mt-3 text-xs text-gray-500 dark:text-gray-400">
        <a href="/api/debug/channels" target="_blank" className="text-blue-500 hover:underline">
          🔍 Debug: View all channels
        </a>
      </div>
    </div>
  );
} 