import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class ReviewsService {
  constructor(private readonly prisma: PrismaService) {}

  async getAllReviews() {
    return this.prisma.review.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }
}
