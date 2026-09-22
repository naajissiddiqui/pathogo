import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class PackagesService {
  constructor(private readonly prisma: PrismaService) {}

  async getAllCategories() {
    return this.prisma.packageCategory.findMany({
      include: {
        _count: {
          select: { packages: true },
        },
      },
    });
  }

  async getAllPackages(query?: { category?: string; search?: string; popular?: boolean }) {
    const where: any = {};

    if (query?.category && query.category !== 'all') {
      where.categorySlug = query.category;
    }

    if (query?.popular) {
      where.isPopular = true;
    }

    if (query?.search) {
      where.OR = [
        { name: { contains: query.search, mode: 'insensitive' } },
        { description: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    return this.prisma.healthPackage.findMany({
      where,
      include: {
        category: true,
      },
      orderBy: [{ isPopular: 'desc' }, { discountPrice: 'asc' }],
    });
  }

  async getPackageBySlug(slug: string) {
    const pkg = await this.prisma.healthPackage.findUnique({
      where: { slug },
      include: { category: true },
    });

    if (!pkg) {
      throw new NotFoundException(`Health package with slug "${slug}" not found`);
    }

    return pkg;
  }
}
