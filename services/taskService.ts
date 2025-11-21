/**
 * Task Service
 * Handles all task-related API calls
 */

import { apiClient } from './api';
import type { Task } from '../types';

export interface CreateTaskData {
  project_id: string;
  title: string;
  description?: string;
  assigned_to?: string;
  status?: 'pending' | 'in_progress' | 'completed' | 'cancelled';
  priority?: 'low' | 'medium' | 'high' | 'critical';
  due_date?: string;
}

export const taskService = {
  /**
   * Get all tasks for a project
   */
  async getByProject(projectId: string): Promise<Task[]> {
    return apiClient.get<Task[]>(`/tasks/project/${projectId}`);
  },

  /**
   * Get task by ID
   */
  async getById(id: string): Promise<Task> {
    return apiClient.get<Task>(`/tasks/${id}`);
  },

  /**
   * Create new task
   */
  async create(data: CreateTaskData): Promise<Task> {
    return apiClient.post<Task>('/tasks', data);
  },

  /**
   * Update task
   */
  async update(id: string, data: Partial<CreateTaskData>): Promise<Task> {
    return apiClient.put<Task>(`/tasks/${id}`, data);
  },

  /**
   * Delete task
   */
  async delete(id: string): Promise<{ message: string }> {
    return apiClient.delete(`/tasks/${id}`);
  },
};
