import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class TestsService {
  constructor(private readonly prisma: PrismaService) {}

  async getAllCategories() {
    return this.prisma.testCategory.findMany({
      include: {
        _count: {
          select: { tests: true },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  async getAllTests(query?: { category?: string; search?: string }) {
    const where: any = {};

    if (query?.category && query.category !== 'all') {
      where.categorySlug = query.category;
    }

    if (query?.search) {
      where.OR = [
        { name: { contains: query.search, mode: 'insensitive' } },
        { code: { contains: query.search, mode: 'insensitive' } },
        { description: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    return this.prisma.labTest.findMany({
      where,
      include: {
        category: true,
      },
      orderBy: { name: 'asc' },
    });
  }

  async getTestBySlug(slug: string) {
    const test = await this.prisma.labTest.findUnique({
      where: { slug },
      include: { category: true },
    });

    if (!test) {
      throw new NotFoundException(`Lab test with slug "${slug}" not found`);
    }

    return test;
  }
}
