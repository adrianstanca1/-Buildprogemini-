/**
 * Authentication Service
 * Handles all authentication-related API calls
 */

import { apiClient } from './api';
import type { User } from '../types';

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterData {
  email: string;
  password: string;
  name: string;
  role?: 'super_admin' | 'company_admin' | 'supervisor' | 'operative';
  company_name?: string;
}

export interface AuthResponse {
  token: string;
  user: User;
}

export const authService = {
  /**
   * Login user
   */
  async login(credentials: LoginCredentials): Promise<AuthResponse> {
    const response = await apiClient.post<AuthResponse>('/auth/login', credentials);
    apiClient.setToken(response.token);
    return response;
  },

  /**
   * Register new user
   */
  async register(data: RegisterData): Promise<AuthResponse> {
    const response = await apiClient.post<AuthResponse>('/auth/register', data);
    apiClient.setToken(response.token);
    return response;
  },

  /**
   * Get current user profile
   */
  async getProfile(): Promise<User> {
    return apiClient.get<User>('/auth/profile');
  },

  /**
   * Update user profile
   */
  async updateProfile(data: Partial<User>): Promise<User> {
    return apiClient.put<User>('/auth/profile', data);
  },

  /**
   * Logout user
   */
  logout(): void {
    apiClient.setToken(null);
  },

  /**
   * Check if user is authenticated
   */
  isAuthenticated(): boolean {
    return !!apiClient.getToken();
  },
};
