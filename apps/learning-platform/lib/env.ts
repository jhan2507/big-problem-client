import { z } from 'zod';

const PublicEnvSchema = z.object({
  NEXT_PUBLIC_API_BASE_URL: z.string().url().optional(),
});

export function getPublicEnv() {
  const parsed = PublicEnvSchema.safeParse({
    NEXT_PUBLIC_API_BASE_URL: process.env.NEXT_PUBLIC_API_BASE_URL,
  });
  if (!parsed.success) return { NEXT_PUBLIC_API_BASE_URL: undefined as string | undefined };
  return parsed.data;
}

