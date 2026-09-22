import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { AppointmentStatus } from '@prisma/client';

@Injectable()
export class AppointmentsService {
  constructor(private readonly prisma: PrismaService) {}

  private generateAppointmentNumber(): string {
    const randomDigits = Math.floor(1000 + Math.random() * 9000);
    const year = new Date().getFullYear();
    return `DOC-${year}-${randomDigits}`;
  }

  async createAppointment(dto: CreateAppointmentDto) {
    let doctor = await this.prisma.doctor.findFirst({
      where: {
        OR: [
          { id: dto.doctorId },
          { slug: dto.doctorId },
          { name: { contains: dto.doctorId, mode: 'insensitive' } },
        ],
      },
    });

    if (!doctor) {
      doctor = await this.prisma.doctor.findFirst();
    }

    if (!doctor) {
      throw new NotFoundException(`No doctors available in the system`);
    }

    const appointmentNumber = this.generateAppointmentNumber();

    const appointment = await this.prisma.doctorAppointment.create({
      data: {
        appointmentNumber,
        userId: dto.userId || null,
        doctorId: doctor.id,
        patientName: dto.patientName,
        patientEmail: dto.patientEmail,
        patientPhone: dto.patientPhone,
        patientAge: dto.patientAge,
        patientGender: dto.patientGender,
        appointmentDate: new Date(dto.appointmentDate),
        appointmentSlot: dto.appointmentSlot,
        consultationType: dto.consultationType || 'VIDEO',
        symptoms: dto.symptoms,
        consultationFee: doctor.consultationFee,
        status: AppointmentStatus.CONFIRMED,
      },
      include: {
        doctor: true,
      },
    });

    return appointment;
  }

  async getAppointmentByNumber(appointmentNumber: string) {
    const appointment = await this.prisma.doctorAppointment.findUnique({
      where: { appointmentNumber },
      include: {
        doctor: true,
      },
    });

    if (!appointment) {
      throw new NotFoundException(`Appointment "${appointmentNumber}" not found`);
    }

    return appointment;
  }

  async getAppointmentsByPhone(phone: string) {
    const cleanPhone = phone.replace(/[^0-9]/g, '');
    return this.prisma.doctorAppointment.findMany({
      where: {
        patientPhone: {
          contains: cleanPhone,
        },
      },
      include: {
        doctor: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
