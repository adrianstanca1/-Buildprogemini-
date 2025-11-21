import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { ProjectModel } from '../models/Project.js';
import { AppError } from '../middleware/errorHandler.js';

export class ProjectController {
  static async getAll(req: Request, res: Response) {
    try {
      const projects = await ProjectModel.findAll();
      res.json({ success: true, data: projects });
    } catch (error) {
      throw new AppError('Failed to fetch projects', 500);
    }
  }

  static async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const project = await ProjectModel.findById(id);

      if (!project) {
        throw new AppError('Project not found', 404);
      }

      res.json({ success: true, data: project });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to fetch project', 500);
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const projectData = {
        id: uuidv4(),
        ...req.body,
      };

      const project = await ProjectModel.create(projectData);
      res.status(201).json({ success: true, data: project });
    } catch (error) {
      throw new AppError('Failed to create project', 500);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const project = await ProjectModel.update(id, req.body);

      if (!project) {
        throw new AppError('Project not found', 404);
      }

      res.json({ success: true, data: project });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to update project', 500);
    }
  }

  static async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const deleted = await ProjectModel.delete(id);

      if (!deleted) {
        throw new AppError('Project not found', 404);
      }

      res.json({ success: true, message: 'Project deleted successfully' });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to delete project', 500);
    }
  }
}
