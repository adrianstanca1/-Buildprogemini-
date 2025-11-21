import express from 'express';
import { body } from 'express-validator';
import { TeamController } from '../controllers/teamController.js';
import { validate } from '../middleware/validation.js';
import { authenticate, authorize } from '../middleware/auth.js';

const router = express.Router();

router.get(
  '/',
  authenticate,
  (req, res, next) => TeamController.getAll(req, res).catch(next)
);

router.get(
  '/:id',
  authenticate,
  (req, res, next) => TeamController.getById(req, res).catch(next)
);

router.post(
  '/',
  authenticate,
  authorize('super_admin', 'company_admin'),
  [
    body('name').notEmpty().trim(),
    body('initials').notEmpty().trim(),
    body('role').notEmpty().trim(),
    body('status').isIn(['On Site', 'Off Site', 'On Break', 'Leave']),
    body('phone').notEmpty().trim(),
    body('email').isEmail().normalizeEmail(),
    body('color').notEmpty().trim(),
    validate,
  ],
  (req, res, next) => TeamController.create(req, res).catch(next)
);

router.put(
  '/:id',
  authenticate,
  (req, res, next) => TeamController.update(req, res).catch(next)
);

router.delete(
  '/:id',
  authenticate,
  authorize('super_admin', 'company_admin'),
  (req, res, next) => TeamController.delete(req, res).catch(next)
);

export default router;
