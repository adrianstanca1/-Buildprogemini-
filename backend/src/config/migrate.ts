import pool from './database.js';
import logger from './logger.js';

const createTables = async () => {
  try {
    logger.info('Starting database migration...');

    // Users table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        phone VARCHAR(50),
        role VARCHAR(50) NOT NULL DEFAULT 'operative',
        company_id VARCHAR(255),
        avatar_initials VARCHAR(10),
        avatar_url TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    logger.info('✅ Users table created');

    // Projects table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS projects (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        code VARCHAR(100) UNIQUE NOT NULL,
        description TEXT,
        location VARCHAR(255),
        type VARCHAR(50) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'Planning',
        health VARCHAR(50) NOT NULL DEFAULT 'Good',
        progress INTEGER DEFAULT 0,
        budget DECIMAL(15, 2) DEFAULT 0,
        spent DECIMAL(15, 2) DEFAULT 0,
        start_date DATE,
        end_date DATE,
        manager VARCHAR(255),
        image TEXT,
        team_size INTEGER DEFAULT 0,
        total_tasks INTEGER DEFAULT 0,
        completed_tasks INTEGER DEFAULT 0,
        overdue_tasks INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    logger.info('✅ Projects table created');

    // Tasks table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS tasks (
        id VARCHAR(255) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        project_id VARCHAR(255) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'To Do',
        priority VARCHAR(50) NOT NULL DEFAULT 'Medium',
        assignee_id VARCHAR(255),
        assignee_name VARCHAR(255),
        assignee_type VARCHAR(50) NOT NULL DEFAULT 'user',
        due_date DATE,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
      )
    `);
    logger.info('✅ Tasks table created');

    // Team Members table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS team_members (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        initials VARCHAR(10) NOT NULL,
        role VARCHAR(100) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'Off Site',
        project_id VARCHAR(255),
        phone VARCHAR(50) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        color VARCHAR(50),
        bio TEXT,
        location VARCHAR(255),
        join_date DATE,
        skills TEXT[],
        performance_rating INTEGER,
        completed_projects INTEGER DEFAULT 0,
        hourly_rate DECIMAL(10, 2),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL
      )
    `);
    logger.info('✅ Team Members table created');

    // Documents table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS documents (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        type VARCHAR(50) NOT NULL,
        project_id VARCHAR(255) NOT NULL,
        size VARCHAR(50),
        date DATE,
        status VARCHAR(50) NOT NULL DEFAULT 'Draft',
        url TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
      )
    `);
    logger.info('✅ Documents table created');

    // Clients table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS clients (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        contact_person VARCHAR(255),
        role VARCHAR(100),
        email VARCHAR(255),
        phone VARCHAR(50),
        status VARCHAR(50) NOT NULL DEFAULT 'Lead',
        tier VARCHAR(50),
        active_projects INTEGER DEFAULT 0,
        total_value VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    logger.info('✅ Clients table created');

    // Inventory table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS inventory (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        category VARCHAR(100),
        stock INTEGER DEFAULT 0,
        unit VARCHAR(50),
        threshold INTEGER DEFAULT 0,
        location VARCHAR(255),
        status VARCHAR(50) NOT NULL DEFAULT 'In Stock',
        last_order_date DATE,
        cost_per_unit DECIMAL(10, 2),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    logger.info('✅ Inventory table created');

    logger.info('✅ All tables created successfully!');
  } catch (error) {
    logger.error('❌ Migration failed:', error);
    throw error;
  }
};

// Run migration
try {
  await createTables();
  logger.info('Migration completed successfully');
  process.exit(0);
} catch (error) {
  logger.error('Migration failed:', error);
  process.exit(1);
}
