import React, { createContext, useContext, useState, ReactNode } from 'react';
import { UserProfile, UserRole } from '../types';
import { authService, type LoginCredentials, type RegisterData } from '../services/authService';
import type { ApiError } from '../services/api';

interface AuthContextType {
  user: UserProfile | null;
  login: (credentials: LoginCredentials) => Promise<void>;
  register: (data: RegisterData) => Promise<void>;
  logout: () => void;
  hasPermission: (allowedRoles: UserRole[]) => boolean;
  addProjectId: (id: string) => void;
  isLoading: boolean;
  error: string | null;
  clearError: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<UserProfile | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const login = async (credentials: LoginCredentials): Promise<void> => {
    try {
      setIsLoading(true);
      setError(null);
      const response = await authService.login(credentials);
      setUser(response.user);
    } catch (err) {
      const errorMessage = (err as ApiError).message || 'Login failed';
      setError(errorMessage);
      throw err;
    } finally {
      setIsLoading(false);
    }
  };

  const register = async (data: RegisterData): Promise<void> => {
    try {
      setIsLoading(true);
      setError(null);
      const response = await authService.register(data);
      setUser(response.user);
    } catch (err) {
      const errorMessage = (err as ApiError).message || 'Registration failed';
      setError(errorMessage);
      throw err;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = () => {
    setUser(null);
    authService.logout();
  };

  const hasPermission = (allowedRoles: UserRole[]) => {
    if (!user) return false;
    return allowedRoles.includes(user.role);
  };

  const addProjectId = (projectId: string) => {
    if (user?.projectIds && !user.projectIds.includes(projectId) && !user.projectIds.includes('ALL')) {
      setUser({
        ...user,
        projectIds: [...user.projectIds, projectId],
      });
    }
  };

  const clearError = () => {
    setError(null);
  };

  const value = React.useMemo(
    () => ({
      user,
      login,
      register,
      logout,
      hasPermission,
      addProjectId,
      isLoading,
      error,
      clearError,
    }),
    [user, isLoading, error]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};