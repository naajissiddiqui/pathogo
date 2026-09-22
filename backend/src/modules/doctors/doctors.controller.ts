import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { DoctorsService } from './doctors.service';

@ApiTags('Doctors & Specialists')
@Controller('doctors')
export class DoctorsController {
  constructor(private readonly doctorsService: DoctorsService) {}

  @Get('specialties')
  @ApiOperation({ summary: 'Get list of medical specialties' })
  async getSpecialties() {
    const data = await this.doctorsService.getSpecialties();
    return {
      message: 'Medical specialties fetched successfully',
      data,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Get all doctors with specialty and search filters' })
  @ApiQuery({ name: 'specialty', required: false, type: String, description: 'Specialty slug e.g. cardiology, nephrology' })
  @ApiQuery({ name: 'search', required: false, type: String, description: 'Keyword search for doctor name or hospital' })
  async getDoctors(
    @Query('specialty') specialty?: string,
    @Query('search') search?: string,
  ) {
    const data = await this.doctorsService.getAllDoctors({ specialty, search });
    return {
      message: 'Doctors fetched successfully',
      data,
    };
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get doctor profile and available appointment slots by ID or slug' })
  async getDoctorById(@Param('id') id: string) {
    const data = await this.doctorsService.getDoctorById(id);
    return {
      message: 'Doctor details fetched successfully',
      data,
    };
  }
}
