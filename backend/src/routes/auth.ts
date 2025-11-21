import express from 'express';
import { body } from 'express-validator';
import { AuthController } from '../controllers/authController.js';
import { validate } from '../middleware/validation.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

router.post(
  '/register',
  [
    body('name').notEmpty().trim(),
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 6 }),
    body('role').optional().isIn(['super_admin', 'company_admin', 'supervisor', 'operative']),
    validate,
  ],
  (req, res, next) => AuthController.register(req, res).catch(next)
);

router.post(
  '/login',
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty(),
    validate,
  ],
  (req, res, next) => AuthController.login(req, res).catch(next)
);

router.get(
  '/profile',
  authenticate,
  (req, res, next) => AuthController.getProfile(req, res).catch(next)
);

router.put(
  '/profile',
  authenticate,
  [
    body('name').optional().trim(),
    body('phone').optional().trim(),
    validate,
  ],
  (req, res, next) => AuthController.updateProfile(req, res).catch(next)
);

export default router;
