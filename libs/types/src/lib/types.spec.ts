import { UserSchema } from './types';

describe('types', () => {
  it('parses valid user', () => {
    const user = UserSchema.parse({ id: 'u1', email: 'a@b.com' });
    expect(user.email).toBe('a@b.com');
  });
});
