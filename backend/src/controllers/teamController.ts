import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { TeamMemberModel } from '../models/TeamMember.js';
import { AppError } from '../middleware/errorHandler.js';

export class TeamController {
  static async getAll(req: Request, res: Response) {
    try {
      const { projectId } = req.query;

      const members = projectId
        ? await TeamMemberModel.findByProject(projectId as string)
        : await TeamMemberModel.findAll();

      res.json({ success: true, data: members });
    } catch (error) {
      throw new AppError('Failed to fetch team members', 500);
    }
  }

  static async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const member = await TeamMemberModel.findById(id);

      if (!member) {
        throw new AppError('Team member not found', 404);
      }

      res.json({ success: true, data: member });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to fetch team member', 500);
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const memberData = {
        id: uuidv4(),
        ...req.body,
      };

      const member = await TeamMemberModel.create(memberData);
      res.status(201).json({ success: true, data: member });
    } catch (error) {
      throw new AppError('Failed to create team member', 500);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const member = await TeamMemberModel.update(id, req.body);

      if (!member) {
        throw new AppError('Team member not found', 404);
      }

      res.json({ success: true, data: member });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to update team member', 500);
    }
  }

  static async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const deleted = await TeamMemberModel.delete(id);

      if (!deleted) {
        throw new AppError('Team member not found', 404);
      }

      res.json({ success: true, message: 'Team member deleted successfully' });
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError('Failed to delete team member', 500);
    }
  }
}
