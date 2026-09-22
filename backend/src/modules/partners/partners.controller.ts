import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PartnersService } from './partners.service';

@ApiTags('Lab Partners')
@Controller('partners')
export class PartnersController {
  constructor(private readonly partnersService: PartnersService) {}

  @Get()
  @ApiOperation({ summary: 'Get list of certified diagnostic lab partners' })
  async getPartners() {
    const data = await this.partnersService.getAllPartners();
    return {
      message: 'Lab partners fetched successfully',
      data,
    };
  }
}
