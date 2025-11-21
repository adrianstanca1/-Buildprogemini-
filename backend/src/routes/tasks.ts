import express from 'express';
import { body } from 'express-validator';
import { TaskController } from '../controllers/taskController.js';
import { validate } from '../middleware/validation.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

router.get(
  '/',
  authenticate,
  (req, res, next) => TaskController.getAll(req, res).catch(next)
);

router.get(
  '/:id',
  authenticate,
  (req, res, next) => TaskController.getById(req, res).catch(next)
);

router.post(
  '/',
  authenticate,
  [
    body('title').notEmpty().trim(),
    body('project_id').notEmpty(),
    body('status').isIn(['To Do', 'In Progress', 'Done', 'Blocked']),
    body('priority').isIn(['High', 'Medium', 'Low']),
    body('assignee_type').isIn(['user', 'role']),
    body('due_date').isISO8601(),
    validate,
  ],
  (req, res, next) => TaskController.create(req, res).catch(next)
);

router.put(
  '/:id',
  authenticate,
  (req, res, next) => TaskController.update(req, res).catch(next)
);

router.delete(
  '/:id',
  authenticate,
  (req, res, next) => TaskController.delete(req, res).catch(next)
);

export default router;
