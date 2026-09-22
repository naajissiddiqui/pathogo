import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { BookingStatus } from '@prisma/client';

@Injectable()
export class BookingsService {
  constructor(private readonly prisma: PrismaService) {}

  private generateBookingNumber(): string {
    const randomDigits = Math.floor(1000 + Math.random() * 9000);
    const year = new Date().getFullYear();
    return `PTG-${year}-${randomDigits}`;
  }

  async createBooking(dto: CreateBookingDto) {
    if ((!dto.packageIds || dto.packageIds.length === 0) && (!dto.testIds || dto.testIds.length === 0)) {
      throw new BadRequestException('At least one health package or lab test must be selected for booking');
    }

    let packages: any[] = [];
    if (dto.packageIds && dto.packageIds.length > 0) {
      packages = await this.prisma.healthPackage.findMany({
        where: {
          OR: [
            { id: { in: dto.packageIds } },
            { slug: { in: dto.packageIds } },
            { name: { in: dto.packageIds } },
          ],
        },
      });
    }

    let tests: any[] = [];
    if (dto.testIds && dto.testIds.length > 0) {
      tests = await this.prisma.labTest.findMany({
        where: {
          OR: [
            { id: { in: dto.testIds } },
            { slug: { in: dto.testIds } },
            { name: { in: dto.testIds } },
          ],
        },
      });
    }

    if (packages.length === 0 && tests.length === 0) {
      packages = await this.prisma.healthPackage.findMany({ take: 1 });
      if (packages.length === 0) {
        tests = await this.prisma.labTest.findMany({ take: 1 });
      }
    }

    if (packages.length === 0 && tests.length === 0) {
      throw new BadRequestException('No diagnostic packages or tests available');
    }

    const packageSubtotal = packages.reduce((sum, p) => sum + p.discountPrice, 0);
    const testSubtotal = tests.reduce((sum, t) => sum + t.price, 0);
    const subtotal = packageSubtotal + testSubtotal;

    let discountAmount = 0;
    if (dto.couponCode) {
      const code = dto.couponCode.trim().toUpperCase();
      if (code === 'FLEBO2050' || code === 'PATHOGO20') {
        discountAmount = Math.round(subtotal * 0.2 * 100) / 100;
      } else if (code === 'FIRST50') {
        discountAmount = Math.round(Math.min(subtotal * 0.5, 500) * 100) / 100;
      }
    }

    const totalAmount = Math.max(0, subtotal - discountAmount);
    const bookingNumber = this.generateBookingNumber();

    const booking = await this.prisma.testBooking.create({
      data: {
        bookingNumber,
        userId: dto.userId || null,
        patientName: dto.patientName,
        patientEmail: dto.patientEmail,
        patientPhone: dto.patientPhone,
        patientAge: dto.patientAge,
        patientGender: dto.patientGender,
        collectionType: dto.collectionType,
        address: dto.address,
        city: dto.city || 'Delhi NCR',
        pincode: dto.pincode,
        scheduledDate: new Date(dto.scheduledDate),
        scheduledSlot: dto.scheduledSlot,
        couponCode: dto.couponCode,
        discountAmount,
        totalAmount,
        status: BookingStatus.CONFIRMED,
        notes: dto.notes,
        items: {
          create: [
            ...packages.map((pkg) => ({
              packageId: pkg.id,
              unitPrice: pkg.discountPrice,
              quantity: 1,
            })),
            ...tests.map((test) => ({
              testId: test.id,
              unitPrice: test.price,
              quantity: 1,
            })),
          ],
        },
      },
      include: {
        items: {
          include: {
            package: true,
            test: true,
          },
        },
      },
    });

    return booking;
  }

  async getBookingByNumber(bookingNumber: string) {
    const booking = await this.prisma.testBooking.findUnique({
      where: { bookingNumber },
      include: {
        items: {
          include: {
            package: true,
            test: true,
          },
        },
      },
    });

    if (!booking) {
      throw new NotFoundException(`Booking with reference "${bookingNumber}" not found`);
    }

    return booking;
  }

  async getBookingsByPhone(phone: string) {
    const cleanPhone = phone.replace(/[^0-9]/g, '');
    return this.prisma.testBooking.findMany({
      where: {
        patientPhone: {
          contains: cleanPhone,
        },
      },
      include: {
        items: {
          include: {
            package: true,
            test: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateBookingStatus(id: string, status: BookingStatus) {
    const existing = await this.prisma.testBooking.findUnique({ where: { id } });
    if (!existing) {
      throw new NotFoundException(`Booking not found`);
    }

    return this.prisma.testBooking.update({
      where: { id },
      data: { status },
      include: {
        items: {
          include: {
            package: true,
            test: true,
          },
        },
      },
    });
  }
}
