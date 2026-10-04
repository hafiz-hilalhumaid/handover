// Runs every .sql file in db/migrations that has not run yet, in name order.
// Each file runs inside a transaction: it either applies completely or not at all.
const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const DATABASE_URL =
  process.env.DATABASE_URL || 'postgresql://handover:handover@localhost:5432/handover';
const DIR = path.join(__dirname, 'migrations');

async function main() {
  const client = new Client({ connectionString: DATABASE_URL });
  await client.connect();

  // The ledger: one row per migration that has already run.
  await client.query(`
    CREATE TABLE IF NOT EXISTS schema_migrations (
      version     text         PRIMARY KEY,
      applied_at  timestamptz  NOT NULL DEFAULT now()
    )`);
  const done = new Set(
    (await client.query('SELECT version FROM schema_migrations')).rows.map((r) => r.version)
  );

  const files = fs.readdirSync(DIR).filter((f) => f.endsWith('.sql')).sort();
  for (const file of files) {
    if (done.has(file)) {
      console.log('skip   ' + file);
      continue;
    }
    const sql = fs.readFileSync(path.join(DIR, file), 'utf8');
    try {
      await client.query('BEGIN');
      await client.query(sql);
      await client.query('INSERT INTO schema_migrations (version) VALUES ($1)', [file]);
      await client.query('COMMIT');
      console.log('apply  ' + file);
    } catch (err) {
      await client.query('ROLLBACK');
      console.error('FAILED ' + file + ': ' + err.message);
      process.exitCode = 1;
      break;
    }
  }
  await client.end();
}

main().catch((err) => {
  console.error('Could not run migrations: ' + err.message);
  process.exit(1);
});