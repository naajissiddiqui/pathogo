import {
  IsString,
  IsEmail,
  IsNotEmpty,
  IsEnum,
  IsInt,
  Min,
  Max,
  IsOptional,
  IsArray,
  IsDateString,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CollectionType, Gender } from '@prisma/client';

export class CreateBookingDto {
  @ApiPropertyOptional({ example: 'usr-12345-uuid', description: 'Associated registered User ID' })
  @IsOptional()
  @IsString()
  userId?: string;

  @ApiProperty({ example: 'Aarav Mehta' })
  @IsString()
  @IsNotEmpty({ message: 'Patient name is required' })
  patientName: string;

  @ApiProperty({ example: 'aarav.mehta@example.com' })
  @IsEmail({}, { message: 'A valid email address is required' })
  patientEmail: string;

  @ApiProperty({ example: '9876543210' })
  @IsString()
  @IsNotEmpty({ message: 'Phone number is required' })
  patientPhone: string;

  @ApiProperty({ example: 32 })
  @IsInt()
  @Min(1, { message: 'Age must be at least 1' })
  @Max(120, { message: 'Age cannot exceed 120' })
  patientAge: number;

  @ApiProperty({ enum: Gender, example: Gender.MALE })
  @IsEnum(Gender, { message: 'Gender must be MALE, FEMALE, or OTHER' })
  patientGender: Gender;

  @ApiPropertyOptional({ enum: CollectionType, example: CollectionType.HOME_COLLECTION })
  @IsOptional()
  @IsEnum(CollectionType)
  collectionType?: CollectionType = CollectionType.HOME_COLLECTION;

  @ApiPropertyOptional({ example: 'Flat 402, Sunshine Heights, Sector 45' })
  @IsOptional()
  @IsString()
  address?: string;

  @ApiPropertyOptional({ example: 'Gurugram' })
  @IsOptional()
  @IsString()
  city?: string;

  @ApiPropertyOptional({ example: '122003' })
  @IsOptional()
  @IsString()
  pincode?: string;

  @ApiProperty({ example: '2026-09-25T08:00:00.000Z' })
  @IsDateString({}, { message: 'A valid scheduled date is required' })
  scheduledDate: string;

  @ApiProperty({ example: '08:00 AM - 09:00 AM' })
  @IsString()
  @IsNotEmpty({ message: 'Scheduled time slot is required' })
  scheduledSlot: string;

  @ApiPropertyOptional({ example: 'FLEBO2050' })
  @IsOptional()
  @IsString()
  couponCode?: string;

  @ApiPropertyOptional({ example: 'Fasting sample collection requested' })
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ type: [String], example: ['corporate-health-package'] })
  @IsOptional()
  @IsArray()
  packageIds?: string[];

  @ApiPropertyOptional({ type: [String], example: ['complete-blood-count'] })
  @IsOptional()
  @IsArray()
  testIds?: string[];
}
