import express from 'express';
import { body } from 'express-validator';
import { ProjectController } from '../controllers/projectController.js';
import { validate } from '../middleware/validation.js';
import { authenticate, authorize } from '../middleware/auth.js';

const router = express.Router();

router.get(
  '/',
  authenticate,
  (req, res, next) => ProjectController.getAll(req, res).catch(next)
);

router.get(
  '/:id',
  authenticate,
  (req, res, next) => ProjectController.getById(req, res).catch(next)
);

router.post(
  '/',
  authenticate,
  authorize('super_admin', 'company_admin'),
  [
    body('name').notEmpty().trim(),
    body('code').notEmpty().trim(),
    body('description').notEmpty().trim(),
    body('location').notEmpty().trim(),
    body('type').isIn(['Commercial', 'Residential', 'Infrastructure', 'Industrial', 'Healthcare']),
    body('budget').isNumeric(),
    body('start_date').isISO8601(),
    body('end_date').isISO8601(),
    validate,
  ],
  (req, res, next) => ProjectController.create(req, res).catch(next)
);

router.put(
  '/:id',
  authenticate,
  authorize('super_admin', 'company_admin', 'supervisor'),
  (req, res, next) => ProjectController.update(req, res).catch(next)
);

router.delete(
  '/:id',
  authenticate,
  authorize('super_admin', 'company_admin'),
  (req, res, next) => ProjectController.delete(req, res).catch(next)
);

export default router;
