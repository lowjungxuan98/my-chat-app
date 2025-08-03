/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `password` to the `User` table without a default value. This is not possible if the table is not empty.

*/

-- First, add the columns as nullable
ALTER TABLE "public"."User" ADD COLUMN "email" TEXT;
ALTER TABLE "public"."User" ADD COLUMN "password" TEXT;

-- Update existing users with temporary values
UPDATE "public"."User" 
SET "email" = CONCAT("userId", '@temporary.com'),
    "password" = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' -- empty string hash
WHERE "email" IS NULL;

-- Now make the columns required
ALTER TABLE "public"."User" ALTER COLUMN "email" SET NOT NULL;
ALTER TABLE "public"."User" ALTER COLUMN "password" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");
