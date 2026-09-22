import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class DoctorsService {
  constructor(private readonly prisma: PrismaService) {}

  async getSpecialties() {
    const doctors = await this.prisma.doctor.findMany({
      select: { specialty: true, specialtySlug: true },
      distinct: ['specialtySlug'],
    });
    return doctors;
  }

  async getAllDoctors(query?: { specialty?: string; search?: string }) {
    const where: any = {};

    if (query?.specialty && query.specialty !== 'all') {
      where.specialtySlug = query.specialty;
    }

    if (query?.search) {
      where.OR = [
        { name: { contains: query.search, mode: 'insensitive' } },
        { specialty: { contains: query.search, mode: 'insensitive' } },
        { qualification: { contains: query.search, mode: 'insensitive' } },
        { hospital: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    return this.prisma.doctor.findMany({
      where,
      orderBy: [{ rating: 'desc' }, { experienceYrs: 'desc' }],
    });
  }

  async getDoctorById(id: string) {
    const doctor = await this.prisma.doctor.findFirst({
      where: {
        OR: [{ id }, { slug: id }],
      },
    });

    if (!doctor) {
      throw new NotFoundException(`Doctor with identifier "${id}" not found`);
    }

    return doctor;
  }
}
