import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);

  async onModuleInit() {
    try {
      await this.$connect();
      this.logger.log('✅ Connected to PostgreSQL database successfully');
    } catch (error) {
      this.logger.warn(
        '⚠️ PostgreSQL database is not reachable at DATABASE_URL. ' +
        'Please ensure PostgreSQL or Docker is running (e.g. run "docker compose up -d" or start Postgres service). ' +
        'APIs will retry on incoming requests.',
      );
    }
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
