import { pool } from '../config/database.js';

export interface TeamMember {
  id: string;
  name: string;
  initials: string;
  role: string;
  status: 'On Site' | 'Off Site' | 'On Break' | 'Leave';
  project_id?: string;
  phone: string;
  email: string;
  color: string;
  bio?: string;
  location?: string;
  join_date?: string;
  skills?: string[];
  performance_rating?: number;
  completed_projects?: number;
  hourly_rate?: number;
  created_at?: Date;
  updated_at?: Date;
}

export class TeamMemberModel {
  static async findAll(): Promise<TeamMember[]> {
    const result = await pool.query('SELECT * FROM team_members ORDER BY name ASC');
    return result.rows;
  }

  static async findById(id: string): Promise<TeamMember | null> {
    const result = await pool.query('SELECT * FROM team_members WHERE id = $1', [id]);
    return result.rows[0] || null;
  }

  static async findByProject(projectId: string): Promise<TeamMember[]> {
    const result = await pool.query('SELECT * FROM team_members WHERE project_id = $1', [projectId]);
    return result.rows;
  }

  static async create(member: Partial<TeamMember>): Promise<TeamMember> {
    const {
      id, name, initials, role, status, project_id, phone, email,
      color, bio, location, join_date, skills, performance_rating,
      completed_projects, hourly_rate
    } = member;

    const result = await pool.query(
      `INSERT INTO team_members (
        id, name, initials, role, status, project_id, phone, email,
        color, bio, location, join_date, skills, performance_rating,
        completed_projects, hourly_rate
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
      RETURNING *`,
      [id, name, initials, role, status, project_id, phone, email,
       color, bio, location, join_date, skills, performance_rating,
       completed_projects, hourly_rate]
    );

    return result.rows[0];
  }

  static async update(id: string, updates: Partial<TeamMember>): Promise<TeamMember | null> {
    const fields = Object.keys(updates)
      .filter(key => key !== 'id')
      .map((key, index) => `${key} = $${index + 2}`)
      .join(', ');

    const values = Object.keys(updates)
      .filter(key => key !== 'id')
      .map(key => (updates as any)[key]);

    const result = await pool.query(
      `UPDATE team_members SET ${fields}, updated_at = NOW() WHERE id = $1 RETURNING *`,
      [id, ...values]
    );

    return result.rows[0] || null;
  }

  static async delete(id: string): Promise<boolean> {
    const result = await pool.query('DELETE FROM team_members WHERE id = $1', [id]);
    return (result.rowCount || 0) > 0;
  }
}
