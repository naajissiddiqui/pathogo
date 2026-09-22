import { Controller, Get, Post, Body, Param, Query, Patch } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam } from '@nestjs/swagger';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { BookingStatus } from '@prisma/client';

@ApiTags('Test Bookings')
@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new diagnostic test / health package booking' })
  async createBooking(@Body() createBookingDto: CreateBookingDto) {
    const data = await this.bookingsService.createBooking(createBookingDto);
    return {
      message: 'Booking confirmed successfully',
      data,
    };
  }

  @Get('lookup')
  @ApiOperation({ summary: 'Lookup all bookings by patient phone number' })
  @ApiQuery({ name: 'phone', required: true, type: String, description: 'Patient phone number' })
  async getBookingsByPhone(@Query('phone') phone: string) {
    const data = await this.bookingsService.getBookingsByPhone(phone);
    return {
      message: 'Bookings retrieved successfully',
      data,
    };
  }

  @Get(':bookingNumber')
  @ApiOperation({ summary: 'Get booking status and details by booking number (e.g. PTG-2026-9812)' })
  @ApiParam({ name: 'bookingNumber', required: true, example: 'PTG-2026-9812' })
  async getBookingByNumber(@Param('bookingNumber') bookingNumber: string) {
    const data = await this.bookingsService.getBookingByNumber(bookingNumber);
    return {
      message: 'Booking details retrieved successfully',
      data,
    };
  }

  @Patch(':id/status')
  @ApiOperation({ summary: 'Update status of a booking (Admin/Lab use)' })
  async updateStatus(
    @Param('id') id: string,
    @Body('status') status: BookingStatus,
  ) {
    const data = await this.bookingsService.updateBookingStatus(id, status);
    return {
      message: 'Booking status updated successfully',
      data,
    };
  }
}
