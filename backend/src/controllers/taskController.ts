import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { TaskModel } from '../models/Task.js';
import { AppError } from '../middleware/errorHandler.js';

export class TaskController {
  static async getAll(req: Request, res: Response) {
    try {
      const { projectId } = req.query;

      const tasks = projectId
        ? await TaskModel.findByProject(projectId as string)
        : await TaskModel.findAll();

      res.json({ success: true, data: tasks });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to fetch tasks', 500);
    }
  }

  static async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const task = await TaskModel.findById(id);

      if (!task) {
        throw new AppError('Task not found', 404);
      }

      res.json({ success: true, data: task });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to fetch task', 500);
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const taskData = {
        id: uuidv4(),
        ...req.body,
      };

      const task = await TaskModel.create(taskData);
      res.status(201).json({ success: true, data: task });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to create task', 500);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const task = await TaskModel.update(id, req.body);

      if (!task) {
        throw new AppError('Task not found', 404);
      }

      res.json({ success: true, data: task });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to update task', 500);
    }
  }

  static async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const deleted = await TaskModel.delete(id);

      if (!deleted) {
        throw new AppError('Task not found', 404);
      }

      res.json({ success: true, message: 'Task deleted successfully' });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to delete task', 500);
    }
  }
}
