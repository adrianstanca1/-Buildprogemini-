import { pool } from '../config/database.js';

export interface Task {
  id: string;
  title: string;
  project_id: string;
  status: 'To Do' | 'In Progress' | 'Done' | 'Blocked';
  priority: 'High' | 'Medium' | 'Low';
  assignee_id?: string;
  assignee_name?: string;
  assignee_type: 'user' | 'role';
  due_date: string;
  description?: string;
  created_at?: Date;
  updated_at?: Date;
}

export class TaskModel {
  static async findAll(): Promise<Task[]> {
    const result = await pool.query('SELECT * FROM tasks ORDER BY due_date ASC');
    return result.rows;
  }

  static async findById(id: string): Promise<Task | null> {
    const result = await pool.query('SELECT * FROM tasks WHERE id = $1', [id]);
    return result.rows[0] || null;
  }

  static async findByProject(projectId: string): Promise<Task[]> {
    const result = await pool.query('SELECT * FROM tasks WHERE project_id = $1 ORDER BY due_date ASC', [projectId]);
    return result.rows;
  }

  static async create(task: Partial<Task>): Promise<Task> {
    const {
      id, title, project_id, status, priority, assignee_id,
      assignee_name, assignee_type, due_date, description
    } = task;

    const result = await pool.query(
      `INSERT INTO tasks (
        id, title, project_id, status, priority, assignee_id,
        assignee_name, assignee_type, due_date, description
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
      RETURNING *`,
      [id, title, project_id, status, priority, assignee_id,
       assignee_name, assignee_type, due_date, description]
    );

    return result.rows[0];
  }

  static async update(id: string, updates: Partial<Task>): Promise<Task | null> {
    const fields = Object.keys(updates)
      .filter(key => key !== 'id')
      .map((key, index) => `${key} = $${index + 2}`)
      .join(', ');

    const values = Object.keys(updates)
      .filter(key => key !== 'id')
      .map(key => (updates as any)[key]);

    const result = await pool.query(
      `UPDATE tasks SET ${fields}, updated_at = NOW() WHERE id = $1 RETURNING *`,
      [id, ...values]
    );

    return result.rows[0] || null;
  }

  static async delete(id: string): Promise<boolean> {
    const result = await pool.query('DELETE FROM tasks WHERE id = $1', [id]);
    return (result.rowCount || 0) > 0;
  }
}
