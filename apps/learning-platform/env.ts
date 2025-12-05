import { z } from 'zod';

const publicSchema = z.object({
  NEXT_PUBLIC_API_BASE_URL: z.string().optional(),
  NEXT_PUBLIC_SITE_URL: z.string().optional(),
});

const serverSchema = z.object({
  MONGODB_URI: z.string().optional(),
  REDIS_URL: z.string().optional(),
});

export const env = {
  public: publicSchema.parse({
    NEXT_PUBLIC_API_BASE_URL: process.env.NEXT_PUBLIC_API_BASE_URL,
    NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL,
  }),
  server: serverSchema.parse({
    MONGODB_URI: process.env.MONGODB_URI,
    REDIS_URL: process.env.REDIS_URL,
  }),
};

