import express from 'express';
import authRoutes from './auth.js';
import projectRoutes from './projects.js';
import taskRoutes from './tasks.js';
import teamRoutes from './team.js';

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/projects', projectRoutes);
router.use('/tasks', taskRoutes);
router.use('/team', teamRoutes);

// Health check
router.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    service: 'BuildPro API'
  });
});

export default router;
