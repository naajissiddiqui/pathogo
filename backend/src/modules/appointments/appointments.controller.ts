import { Controller, Get, Post, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam } from '@nestjs/swagger';
import { AppointmentsService } from './appointments.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';

@ApiTags('Doctor Appointments')
@Controller('appointments')
export class AppointmentsController {
  constructor(private readonly appointmentsService: AppointmentsService) {}

  @Post()
  @ApiOperation({ summary: 'Book a consultation appointment with a doctor' })
  async createAppointment(@Body() createAppointmentDto: CreateAppointmentDto) {
    const data = await this.appointmentsService.createAppointment(createAppointmentDto);
    return {
      message: 'Doctor consultation booked successfully',
      data,
    };
  }

  @Get('lookup')
  @ApiOperation({ summary: 'Lookup doctor appointments by patient phone number' })
  @ApiQuery({ name: 'phone', required: true, type: String, description: 'Patient phone number' })
  async getAppointmentsByPhone(@Query('phone') phone: string) {
    const data = await this.appointmentsService.getAppointmentsByPhone(phone);
    return {
      message: 'Doctor appointments retrieved successfully',
      data,
    };
  }

  @Get(':appointmentNumber')
  @ApiOperation({ summary: 'Get doctor appointment details by appointment number (e.g. DOC-2026-4412)' })
  @ApiParam({ name: 'appointmentNumber', required: true, example: 'DOC-2026-4412' })
  async getAppointmentByNumber(@Param('appointmentNumber') appointmentNumber: string) {
    const data = await this.appointmentsService.getAppointmentByNumber(appointmentNumber);
    return {
      message: 'Appointment details retrieved successfully',
      data,
    };
  }
}
