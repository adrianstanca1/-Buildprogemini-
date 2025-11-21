import pool from './database.js';
import logger from './logger.js';
import bcrypt from 'bcryptjs';

const seedData = async () => {
  try {
    logger.info('Starting database seeding...');

    // Check if data already exists
    const projectCheck = await pool.query('SELECT COUNT(*) FROM projects');
    if (Number.parseInt(projectCheck.rows[0].count) > 0) {
      logger.info('Database already seeded, skipping...');
      return;
    }

    // Seed Users
    const passwordHash = await bcrypt.hash('password123', 10);
    await pool.query(`
      INSERT INTO users (id, name, email, password_hash, phone, role, avatar_initials)
      VALUES 
        ('u1', 'John Anderson', 'john@buildpro.com', $1, '+44 7700 900001', 'super_admin', 'JA'),
        ('u2', 'Sarah Mitchell', 'sarah@buildpro.com', $1, '+44 7700 900002', 'company_admin', 'SM'),
        ('u3', 'David Chen', 'david@buildpro.com', $1, '+44 7700 900003', 'supervisor', 'DC')
    `, [passwordHash]);
    logger.info('✅ Users seeded');

    // Seed Projects
    await pool.query(`
      INSERT INTO projects (
        id, name, code, description, location, type, status, health,
        progress, budget, spent, start_date, end_date, manager, image,
        team_size, total_tasks, completed_tasks, overdue_tasks
      ) VALUES 
        ('p1', 'City Centre Plaza Development', 'CCP-2025',
         'A mixed-use development featuring 40 stories of office space and a luxury retail podium.',
         'Downtown Metro', 'Commercial', 'Active', 'Good', 74, 25000000, 18500000,
         '2025-01-15', '2026-12-31', 'John Anderson',
         'https://images.unsplash.com/photo-1541888946425-d81bb19240f5',
         24, 145, 98, 2),
        ('p2', 'Residential Complex - Phase 2', 'RCP-002',
         'Three tower residential complex with 400 units and shared amenities.',
         'Westside Heights', 'Residential', 'Active', 'At Risk', 45, 18000000, 16500000,
         '2025-02-01', '2025-11-30', 'Sarah Mitchell',
         'https://images.unsplash.com/photo-1590069261209-f8e9b8642343',
         18, 200, 80, 12),
        ('p3', 'Highway Bridge Repair', 'HWY-95-REP',
         'Structural reinforcement and resurfacing of the I-95 overpass.',
         'Interstate 95', 'Infrastructure', 'Active', 'Good', 12, 3200000, 400000,
         '2025-10-01', '2026-04-01', 'David Chen',
         'https://images.unsplash.com/photo-1545558014-8692077e9b5c',
         45, 50, 5, 0)
    `);
    logger.info('✅ Projects seeded');

    // Seed Tasks
    await pool.query(`
      INSERT INTO tasks (
        id, title, project_id, status, priority, assignee_name, assignee_type, due_date
      ) VALUES 
        ('t1', 'Safety inspection - Site A', 'p1', 'To Do', 'High', 'Mike T.', 'user', '2025-11-25'),
        ('t2', 'Concrete pouring - Level 2', 'p1', 'To Do', 'High', 'All Operatives', 'role', '2025-11-28'),
        ('t3', 'Complete foundation excavation', 'p1', 'In Progress', 'High', 'David C.', 'user', '2025-11-26'),
        ('t4', 'Install steel framework', 'p1', 'Done', 'High', 'David C.', 'user', '2025-11-20'),
        ('t5', 'Quality control inspection', 'p3', 'To Do', 'High', 'Tom H.', 'user', '2025-11-27')
    `);
    logger.info('✅ Tasks seeded');

    // Seed Team Members
    await pool.query(`
      INSERT INTO team_members (
        id, name, initials, role, status, project_id, phone, email, color,
        bio, location, skills, performance_rating, completed_projects
      ) VALUES 
        ('tm1', 'John Anderson', 'JA', 'Principal Admin', 'On Site', 'p1',
         '+44 7700 900001', 'john@buildpro.com', 'bg-[#0f5c82]',
         '20+ years in construction management. Specialized in large-scale commercial and infrastructure projects.',
         'London, UK', ARRAY['Strategic Planning', 'Budget Management', 'Stakeholder Relations'],
         98, 42),
        ('tm2', 'Mike Thompson', 'MT', 'Project Manager', 'On Site', 'p1',
         '+44 7700 900003', 'mike@buildpro.com', 'bg-[#1f7d98]',
         'Hands-on project manager with a background in civil engineering.',
         'London, UK', ARRAY['Civil Engineering', 'Site Safety', 'AutoCAD'],
         88, 12)
    `);
    logger.info('✅ Team members seeded');

    // Seed Clients
    await pool.query(`
      INSERT INTO clients (
        id, name, contact_person, role, email, phone, status, tier, active_projects, total_value
      ) VALUES 
        ('c1', 'Metro Development Group', 'Alice Walker', 'Director of Operations',
         'alice@metrodev.com', '(555) 123-4567', 'Active', 'Gold', 3, '£45.2M')
    `);
    logger.info('✅ Clients seeded');

    // Seed Inventory
    await pool.query(`
      INSERT INTO inventory (
        id, name, category, stock, unit, threshold, status, location, last_order_date, cost_per_unit
      ) VALUES 
        ('INV-001', 'Portland Cement Type I', 'Raw Materials', 450, 'Bags', 100,
         'In Stock', 'Warehouse A', '2025-10-20', 12.50),
        ('INV-002', 'Steel Rebar 12mm', 'Raw Materials', 800, 'Pieces', 200,
         'In Stock', 'Warehouse B', '2025-10-18', 8.75)
    `);
    logger.info('✅ Inventory seeded');

    logger.info('✅ All seed data inserted successfully!');
  } catch (error) {
    logger.error('❌ Seeding failed:', error);
    throw error;
  }
};

// Run seeding
try {
  await seedData();
  logger.info('Seeding completed successfully');
  process.exit(0);
} catch (error) {
  logger.error('Seeding failed:', error);
  process.exit(1);
}
