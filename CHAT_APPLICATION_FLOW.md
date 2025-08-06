# Chat Application Flow Documentation

## Overview
This document explains the flow and architecture of the chat application built with Next.js, Stream Chat, and React. The application provides a responsive chat interface that adapts to both desktop and mobile devices.

## Component Architecture

### 1. Main Chat Page (`page.tsx`)
**Purpose**: The main orchestrator component that manages the chat client initialization and overall layout.

**Key Responsibilities**:
- Initialize Stream Chat client with API key
- Handle user authentication and token generation
- Manage chat client state and user connection
- Control responsive layout switching between mobile and desktop views
- Set up channel filters for user-specific channels

**Flow**:
1. **Authentication Check**: Verifies if user is logged in, redirects to login if not
2. **Chat Client Initialization**: 
   - Creates Stream Chat instance
   - Fetches user token from `/api/token` endpoint
   - Connects user to Stream Chat
   - Sets up channel filters for messaging channels where user is a member
3. **Responsive State Management**: Handles mobile/desktop view switching
4. **Component Rendering**: Conditionally renders `ChannelSidebar` and `ChatArea` based on device type and state

**Critical Dependencies**:
- `StreamChat` from stream-chat library
- Authentication context for user state
- Mobile context for responsive behavior
- Router for navigation

### 2. Mobile Context (`MobileContext.tsx`)
**Purpose**: Provides responsive behavior detection across the application.

**Key Responsibilities**:
- Detect screen size changes
- Provide `isMobile` boolean to child components
- Handle window resize events
- Set mobile breakpoint at 768px

**Implementation**:
- Uses `useState` and `useEffect` to track window width
- Provides context through React Context API
- Automatically updates when window is resized

### 3. Channel Sidebar (`ChannelSidebar.tsx`)
**Purpose**: Displays the list of available channels for the user.

**Key Responsibilities**:
- Render channel list using Stream Chat's `ChannelList` component
- Handle responsive width (full width on mobile, 320px on desktop)
- Pass channel selection callbacks to preview components
- Enable channel search functionality

**Props**:
- `filters`: Channel filters to show only relevant channels
- `sort`: Sorting criteria (by last message time)
- `isMobile`: Boolean for responsive behavior
- `onChannelSelect`: Callback when channel is selected

### 4. Custom Channel Preview (`CustomChannelPreview.tsx`)
**Purpose**: Custom UI component for displaying individual channels in the sidebar.

**Key Responsibilities**:
- Display channel information (title, last message, timestamp)
- Show unread message count with badge
- Distinguish between group channels and direct messages
- Handle channel selection with proper callbacks

**Visual Features**:
- **Group Channels**: Blue background with Users icon
- **Direct Messages**: Gray background with Hash icon
- **Unread Badge**: Blue circular badge with count
- **Timestamp**: Shows last message time
- **Hover Effects**: Gray background on hover

**Channel Type Detection**:
- Determines if channel is group based on member count (>2 members = group)
- Uses different icons and styling accordingly

### 5. Chat Area (`ChatArea.tsx`)
**Purpose**: Main chat interface where messages are displayed and sent.

**Key Responsibilities**:
- Render Stream Chat's core components (`Channel`, `Window`, `MessageList`, `MessageInput`)
- Handle mobile-specific header with back button
- Manage responsive layout (full width on mobile, flex-1 on desktop)
- Support thread functionality

**Components Used**:
- `Channel`: Stream Chat channel wrapper
- `Window`: Main chat window container
- `ChannelHeader`: Channel information header
- `MessageList`: Scrollable message history
- `MessageInput`: Message composition area
- `Thread`: Thread view for message replies

### 6. Mobile Chat Header (`MobileChatHeader.tsx`)
**Purpose**: Provides navigation back to channel list on mobile devices.

**Key Responsibilities**:
- Display back button with chevron icon
- Handle navigation back to channel list
- Provide accessible button with proper ARIA labels

**Design**:
- Uses Lucide React's `ChevronLeft` icon
- Hover effects with gray background
- Proper spacing and sizing for mobile interaction

## Application Flow

### Desktop Flow
1. User loads chat page
2. Authentication check passes
3. Chat client initializes
4. Both `ChannelSidebar` and `ChatArea` render side-by-side
5. User can select channels and chat simultaneously

### Mobile Flow
1. User loads chat page
2. Authentication check passes
3. Chat client initializes
4. Initially shows `ChannelSidebar` (channel list)
5. When user selects a channel:
   - `ChannelSidebar` hides
   - `ChatArea` shows with mobile header
   - Back button allows return to channel list
6. User can navigate between channel list and chat area

### State Management Flow
1. **Authentication State**: Managed by `AuthContext`
2. **Mobile Detection**: Managed by `MobileContext`
3. **Chat Client**: Managed in main page component
4. **Channel Selection**: Managed through callbacks and Stream Chat's internal state
5. **View Switching**: Managed by `showChannelList` state in main component

## Component Dependencies

### External Dependencies
- **Stream Chat React**: Core chat functionality
- **Next.js**: Framework and routing
- **Lucide React**: Icons
- **Tailwind CSS**: Styling

### Internal Dependencies
- **AuthContext**: User authentication state
- **MobileContext**: Responsive behavior
- **Custom Components**: Modular UI components

## Key Features

### Responsive Design
- **Desktop**: Side-by-side layout with fixed sidebar
- **Mobile**: Stacked layout with navigation between views
- **Breakpoint**: 768px for mobile detection

### Channel Management
- **Filtering**: Shows only channels where user is a member
- **Sorting**: Channels sorted by last message time
- **Search**: Built-in channel search functionality
- **Types**: Distinguishes between group and direct message channels

### User Experience
- **Loading States**: Proper loading indicators during initialization
- **Error Handling**: Graceful error handling with redirects
- **Navigation**: Intuitive mobile navigation with back buttons
- **Visual Feedback**: Hover effects, unread badges, timestamps

## Security Considerations
- User authentication required for chat access
- Token-based authentication with Stream Chat
- Automatic redirect to login for unauthenticated users
- Secure token generation through API endpoints

## Performance Optimizations
- Conditional rendering based on device type
- Efficient state management with React Context
- Proper cleanup of chat client on component unmount
- Responsive design without unnecessary re-renders 