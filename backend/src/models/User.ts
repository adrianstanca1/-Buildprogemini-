import { pool } from '../config/database.js';
import bcrypt from 'bcryptjs';

export interface User {
  id: string;
  name: string;
  email: string;
  password_hash: string;
  phone?: string;
  role: 'super_admin' | 'company_admin' | 'supervisor' | 'operative';
  company_id?: string;
  avatar_initials?: string;
  avatar_url?: string;
  created_at?: Date;
  updated_at?: Date;
}

export class UserModel {
  static async findAll(): Promise<Omit<User, 'password_hash'>[]> {
    const result = await pool.query('SELECT id, name, email, phone, role, company_id, avatar_initials, avatar_url, created_at FROM users');
    return result.rows;
  }

  static async findById(id: string): Promise<Omit<User, 'password_hash'> | null> {
    const result = await pool.query(
      'SELECT id, name, email, phone, role, company_id, avatar_initials, avatar_url, created_at FROM users WHERE id = $1',
      [id]
    );
    return result.rows[0] || null;
  }

  static async findByEmail(email: string): Promise<User | null> {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    return result.rows[0] || null;
  }

  static async create(user: Partial<User> & { password: string }): Promise<Omit<User, 'password_hash'>> {
    const { id, name, email, password, phone, role, company_id, avatar_initials } = user;
    const password_hash = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `INSERT INTO users (id, name, email, password_hash, phone, role, company_id, avatar_initials)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING id, name, email, phone, role, company_id, avatar_initials, avatar_url, created_at`,
      [id, name, email, password_hash, phone, role, company_id, avatar_initials]
    );

    return result.rows[0];
  }

  static async verifyPassword(email: string, password: string): Promise<boolean> {
    const user = await this.findByEmail(email);
    if (!user) return false;
    return bcrypt.compare(password, user.password_hash);
  }

  static async update(id: string, updates: Partial<User>): Promise<Omit<User, 'password_hash'> | null> {
    const fields = Object.keys(updates)
      .filter(key => key !== 'id' && key !== 'password_hash')
      .map((key, index) => `${key} = $${index + 2}`)
      .join(', ');

    const values = Object.keys(updates)
      .filter(key => key !== 'id' && key !== 'password_hash')
      .map(key => (updates as any)[key]);

    const result = await pool.query(
      `UPDATE users SET ${fields}, updated_at = NOW() WHERE id = $1 
       RETURNING id, name, email, phone, role, company_id, avatar_initials, avatar_url, created_at`,
      [id, ...values]
    );

    return result.rows[0] || null;
  }
}
