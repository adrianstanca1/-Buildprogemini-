/**
 * Project Service
 * Handles all project-related API calls
 */

import { apiClient } from './api';
import type { Project } from '../types';

export interface CreateProjectData {
  name: string;
  description?: string;
  location?: string;
  start_date?: string;
  end_date?: string;
  budget?: number;
  status?: 'planning' | 'in_progress' | 'on_hold' | 'completed' | 'cancelled';
}

export const projectService = {
  /**
   * Get all projects
   */
  async getAll(): Promise<Project[]> {
    return apiClient.get<Project[]>('/projects');
  },

  /**
   * Get project by ID
   */
  async getById(id: string): Promise<Project> {
    return apiClient.get<Project>(`/projects/${id}`);
  },

  /**
   * Create new project
   */
  async create(data: CreateProjectData): Promise<Project> {
    return apiClient.post<Project>('/projects', data);
  },

  /**
   * Update project
   */
  async update(id: string, data: Partial<CreateProjectData>): Promise<Project> {
    return apiClient.put<Project>(`/projects/${id}`, data);
  },

  /**
   * Delete project
   */
  async delete(id: string): Promise<{ message: string }> {
    return apiClient.delete(`/projects/${id}`);
  },
};
