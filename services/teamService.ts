/**
 * Team Service
 * Handles all team member-related API calls
 */

import { apiClient } from './api';
import type { TeamMember } from '../types';

export interface CreateTeamMemberData {
  project_id: string;
  user_id: string;
  role?: 'project_manager' | 'site_supervisor' | 'foreman' | 'worker' | 'subcontractor';
}

export const teamService = {
  /**
   * Get all team members for a project
   */
  async getByProject(projectId: string): Promise<TeamMember[]> {
    return apiClient.get<TeamMember[]>(`/team/project/${projectId}`);
  },

  /**
   * Add team member to project
   */
  async add(data: CreateTeamMemberData): Promise<TeamMember> {
    return apiClient.post<TeamMember>('/team', data);
  },

  /**
   * Update team member role
   */
  async updateRole(
    id: string,
    role: CreateTeamMemberData['role']
  ): Promise<TeamMember> {
    return apiClient.put<TeamMember>(`/team/${id}`, { role });
  },

  /**
   * Remove team member from project
   */
  async remove(id: string): Promise<{ message: string }> {
    return apiClient.delete(`/team/${id}`);
  },
};
