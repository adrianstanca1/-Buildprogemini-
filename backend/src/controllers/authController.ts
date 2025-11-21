import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { UserModel } from '../models/User.js';
import { AppError } from '../middleware/errorHandler.js';

export class AuthController {
  static async register(req: Request, res: Response) {
    try {
      const { name, email, password, phone, role, company_id } = req.body;

      const existingUser = await UserModel.findByEmail(email);
      if (existingUser) {
        throw new AppError('Email already registered', 400);
      }

      const avatar_initials = name
        .split(' ')
        .map((n: string) => n[0])
        .join('')
        .toUpperCase()
        .substring(0, 2);

      const user = await UserModel.create({
        id: uuidv4(),
        name,
        email,
        password,
        phone,
        role: role || 'operative',
        company_id,
        avatar_initials,
      });

      const token = jwt.sign(
        { id: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET || 'secret',
        { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
      );

      res.status(201).json({
        success: true,
        data: { user, token },
      });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Registration failed', 500);
    }
  }

  static async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body;

      const isValid = await UserModel.verifyPassword(email, password);
      if (!isValid) {
        throw new AppError('Invalid email or password', 401);
      }

      const user = await UserModel.findByEmail(email);
      if (!user) {
        throw new AppError('User not found', 404);
      }

      const token = jwt.sign(
        { id: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET || 'secret',
        { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
      );

      const { password_hash, ...userWithoutPassword } = user;

      res.json({
        success: true,
        data: { user: userWithoutPassword, token },
      });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Login failed', 500);
    }
  }

  static async getProfile(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      const user = await UserModel.findById(userId);

      if (!user) {
        throw new AppError('User not found', 404);
      }

      res.json({
        success: true,
        data: user,
      });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to fetch profile', 500);
    }
  }

  static async updateProfile(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      const updates = req.body;

      const user = await UserModel.update(userId, updates);

      if (!user) {
        throw new AppError('User not found', 404);
      }

      res.json({
        success: true,
        data: user,
      });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to update profile', 500);
    }
  }
}
