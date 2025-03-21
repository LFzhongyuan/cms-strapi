import path from 'path';

export default ({ env }) => {
  const client = env('DATABASE_CLIENT', 'mysql');

  const connections = {
    mysql: {
      connection: {
        host: env('DATABASE_HOST', 'localhost'),
        port: env.int('DATABASE_PORT', 3306),
        database: env('DATABASE_NAME', 'strapi'),
        user: env('DATABASE_USERNAME', 'strapi'),
        password: env('DATABASE_PASSWORD', 'strapi'),
        ssl: env.bool('DATABASE_SSL', true) && {
          rejectUnauthorized: env.bool('DATABASE_SSL_REJECT_UNAUTHORIZED', true),
        },
      },
      pool: {
        min: env.int('DATABASE_POOL_MIN', 5),
        max: env.int('DATABASE_POOL_MAX', 20),
        acquireTimeoutMillis: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
        createTimeoutMillis: env.int('DATABASE_CONNECTION_TIMEOUT', 30000),
        idleTimeoutMillis: env.int('DATABASE_CONNECTION_TIMEOUT', 30000),
      },
    },
  };

  return {
    connection: {
      client,
      ...connections[client],
      acquireConnectionTimeout: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
    },
  };
};
