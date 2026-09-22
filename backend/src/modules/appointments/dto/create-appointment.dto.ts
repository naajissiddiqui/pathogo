import {
  IsString,
  IsEmail,
  IsNotEmpty,
  IsEnum,
  IsInt,
  Min,
  Max,
  IsOptional,
  IsDateString,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Gender } from '@prisma/client';

export class CreateAppointmentDto {
  @ApiPropertyOptional({ example: 'usr-12345-uuid', description: 'Associated registered User ID' })
  @IsOptional()
  @IsString()
  userId?: string;

  @ApiProperty({ example: 'dr-priya-sharma' })
  @IsString()
  @IsNotEmpty({ message: 'Doctor identifier is required' })
  doctorId: string;

  @ApiProperty({ example: 'Rohan Gupta' })
  @IsString()
  @IsNotEmpty({ message: 'Patient name is required' })
  patientName: string;

  @ApiProperty({ example: 'rohan.gupta@example.com' })
  @IsEmail({}, { message: 'A valid email address is required' })
  patientEmail: string;

  @ApiProperty({ example: '9811223344' })
  @IsString()
  @IsNotEmpty({ message: 'Phone number is required' })
  patientPhone: string;

  @ApiProperty({ example: 38 })
  @IsInt()
  @Min(1, { message: 'Age must be at least 1' })
  @Max(120, { message: 'Age cannot exceed 120' })
  patientAge: number;

  @ApiProperty({ enum: Gender, example: Gender.MALE })
  @IsEnum(Gender, { message: 'Gender must be MALE, FEMALE, or OTHER' })
  patientGender: Gender;

  @ApiProperty({ example: '2026-09-25T10:00:00.000Z' })
  @IsDateString({}, { message: 'A valid appointment date is required' })
  appointmentDate: string;

  @ApiProperty({ example: '10:00 AM' })
  @IsString()
  @IsNotEmpty({ message: 'Appointment time slot is required' })
  appointmentSlot: string;

  @ApiPropertyOptional({ example: 'VIDEO', default: 'VIDEO' })
  @IsOptional()
  @IsString()
  consultationType?: string = 'VIDEO';

  @ApiPropertyOptional({ example: 'Mild chest heaviness after exertion' })
  @IsOptional()
  @IsString()
  symptoms?: string;
}
