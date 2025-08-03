# Database Setup for My Chat App

## Prisma Integration Complete ✅

The following files have been created/updated:

### 1. Prisma Client Singleton
- **File**: `src/server/lib/prisma.ts`
- **Purpose**: Prevents cold-start issues in Next.js by reusing Prisma client instances

### 2. Database Schema
- **File**: `prisma/schema.prisma`
- **Models**: 
  - `User` - Stores user information with Stream sync
  - `Channel` - Stores channel metadata
  - `ChannelMember` - Junction table for channel memberships

### 3. Updated API Routes

#### Token Route (`src/app/api/token/route.ts`)
- ✅ Upserts user in your database
- ✅ Syncs user to Stream via `serverClient.upsertUser()`
- ✅ Returns Stream token for frontend

#### Create Channel Route (`src/app/api/create-channel/route.ts`)
- ✅ Creates channel in Stream
- ✅ Saves channel and members to your database
- ✅ Returns both Stream CID and database ID

## 🐳 Docker PostgreSQL Setup

### Quick Start
```bash
# Start the database
./scripts/db.sh start

# Check status
./scripts/db.sh status

# View logs
./scripts/db.sh logs
```

### Database Management Commands
```bash
./scripts/db.sh start    # Start PostgreSQL
./scripts/db.sh stop     # Stop PostgreSQL
./scripts/db.sh restart  # Restart PostgreSQL
./scripts/db.sh status   # Show container status
./scripts/db.sh logs     # Show database logs
./scripts/db.sh reset    # Reset database (delete all data)
```

### Manual Docker Commands
```bash
# Start database
docker-compose up -d

# Stop database
docker-compose down

# View logs
docker-compose logs postgres
```

## Database Configuration

### Connection Details
- **Host**: localhost
- **Port**: 5432
- **Database**: my-chat-app
- **Username**: username
- **Password**: password
- **Connection String**: `postgresql://username:password@localhost:5432/my-chat-app`

### Environment Variables
The following are automatically configured:
- `DATABASE_URL` in `.env` file
- Docker container environment variables in `docker-compose.yml`

## Database Models Overview

```prisma
model User {
  id          Int              @id @default(autoincrement())
  userId      String           @unique  // Stream user ID
  name        String?
  image       String?
  lastSeenAt  DateTime?
  createdAt   DateTime         @default(now())
  channels    ChannelMember[]
}

model Channel {
  id         Int      @id @default(autoincrement())
  channelId  String   @unique  // Stream channel ID
  type       String
  name       String
  members    ChannelMember[]
}

model ChannelMember {
  id        Int     @id @default(autoincrement())
  channel   Channel @relation(fields: [channelId], references: [channelId])
  channelId String
  user      User    @relation(fields: [userId], references: [userId])
  userId    String
}
```

## ✅ Setup Complete

Your database is now ready! The following has been completed:

1. ✅ PostgreSQL container running on Docker
2. ✅ Database tables created via Prisma migration
3. ✅ Prisma client generated and ready
4. ✅ API routes updated to use database
5. ✅ Database management scripts created

## Why This Architecture?

1. **Dual Storage**: Your database stores metadata while Stream handles real-time messaging
2. **Sync Strategy**: Users and channels are kept in sync between your DB and Stream
3. **Query Flexibility**: You can now query user/channel data directly from your database
4. **Scalability**: Ready for message persistence via webhooks (next step)
5. **Development Friendly**: Easy local development with Docker

---

**Ready for Step 6.5**: Message saving via Stream webhooks and chat page updates. Say "Continue" when ready! 