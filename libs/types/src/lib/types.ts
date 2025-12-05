import { z } from 'zod';

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string().optional(),
});
export type User = z.infer<typeof UserSchema>;

export const CourseSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string().optional(),
  published: z.boolean().default(false),
});
export type Course = z.infer<typeof CourseSchema>;

export const LessonSchema = z.object({
  id: z.string(),
  courseId: z.string(),
  title: z.string(),
  content: z.string().optional(),
});
export type Lesson = z.infer<typeof LessonSchema>;

export const EnrollmentSchema = z.object({
  userId: z.string(),
  courseId: z.string(),
  enrolledAt: z.date(),
});
export type Enrollment = z.infer<typeof EnrollmentSchema>;
