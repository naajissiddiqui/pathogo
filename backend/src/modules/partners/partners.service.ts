import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class PartnersService {
  constructor(private readonly prisma: PrismaService) {}

  async getAllPartners() {
    return this.prisma.labPartner.findMany({
      orderBy: { rating: 'desc' },
    });
  }
}
