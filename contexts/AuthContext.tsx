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
      
      // Try real backend first, fallback to mock data
      try {
        const response = await authService.login(credentials);
        setUser(response.user);
      } catch (error_) {
        // Fallback to mock authentication for development
        console.warn('Backend not available, using mock auth:', error_);
        const mockUsers: Record<string, UserProfile> = {
          'john@buildcorp.com': {
            id: '1',
            name: 'John Smith',
            email: 'john@buildcorp.com',
            phone: '+1 555-0101',
            role: UserRole.SUPER_ADMIN,
            projectIds: ['ALL'],
            avatarInitials: 'JS'
          },
          'sarah@buildcorp.com': {
            id: '2',
            name: 'Sarah Johnson',
            email: 'sarah@buildcorp.com',
            phone: '+1 555-0102',
            role: UserRole.COMPANY_ADMIN,
            projectIds: ['ALL'],
            avatarInitials: 'SJ'
          },
          'mike@buildcorp.com': {
            id: '3',
            name: 'Mike Wilson',
            email: 'mike@buildcorp.com',
            phone: '+1 555-0103',
            role: UserRole.SUPERVISOR,
            projectIds: ['P001', 'P002'],
            avatarInitials: 'MW'
          },
          'david@buildcorp.com': {
            id: '4',
            name: 'David Brown',
            email: 'david@buildcorp.com',
            phone: '+1 555-0104',
            role: UserRole.OPERATIVE,
            projectIds: ['P001'],
            avatarInitials: 'DB'
          }
        };
        
        const mockUser = mockUsers[credentials.email];
        if (mockUser) {
          setUser(mockUser);
        } else {
          throw new Error('Invalid credentials');
        }
      }
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