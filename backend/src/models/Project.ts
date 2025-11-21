import pool from '../config/database.js';

export interface Project {
  id: string;
  name: string;
  code: string;
  description: string;
  location: string;
  type: 'Commercial' | 'Residential' | 'Infrastructure' | 'Industrial' | 'Healthcare';
  status: 'Active' | 'Planning' | 'Delayed' | 'Completed' | 'On Hold';
  health: 'Good' | 'At Risk' | 'Critical';
  progress: number;
  budget: number;
  spent: number;
  start_date: string;
  end_date: string;
  manager: string;
  image: string;
  team_size: number;
  total_tasks: number;
  completed_tasks: number;
  overdue_tasks: number;
  created_at?: Date;
  updated_at?: Date;
}

export class ProjectModel {
  static async findAll(): Promise<Project[]> {
    const result = await pool.query('SELECT * FROM projects ORDER BY created_at DESC');
    return result.rows;
  }

  static async findById(id: string): Promise<Project | null> {
    const result = await pool.query('SELECT * FROM projects WHERE id = $1', [id]);
    return result.rows[0] || null;
  }

  static async create(project: Partial<Project>): Promise<Project> {
    const {
      id, name, code, description, location, type, status, health,
      progress, budget, spent, start_date, end_date, manager, image,
      team_size, total_tasks, completed_tasks, overdue_tasks
    } = project;

    const result = await pool.query(
      `INSERT INTO projects (
        id, name, code, description, location, type, status, health,
        progress, budget, spent, start_date, end_date, manager, image,
        team_size, total_tasks, completed_tasks, overdue_tasks
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19)
      RETURNING *`,
      [id, name, code, description, location, type, status, health,
       progress, budget, spent, start_date, end_date, manager, image,
       team_size, total_tasks, completed_tasks, overdue_tasks]
    );

    return result.rows[0];
  }

  static async update(id: string, updates: Partial<Project>): Promise<Project | null> {
    const fields = Object.keys(updates)
      .filter(key => key !== 'id')
      .map((key, index) => `${key} = $${index + 2}`)
      .join(', ');

    const values = Object.keys(updates)
      .filter(key => key !== 'id')
      .map(key => (updates as any)[key]);

    const result = await pool.query(
      `UPDATE projects SET ${fields}, updated_at = NOW() WHERE id = $1 RETURNING *`,
      [id, ...values]
    );

    return result.rows[0] || null;
  }

  static async delete(id: string): Promise<boolean> {
    const result = await pool.query('DELETE FROM projects WHERE id = $1', [id]);
    return (result.rowCount || 0) > 0;
  }
}
