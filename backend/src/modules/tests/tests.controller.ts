import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { TestsService } from './tests.service';

@ApiTags('Lab Tests')
@Controller('tests')
export class TestsController {
  constructor(private readonly testsService: TestsService) {}

  @Get('categories')
  @ApiOperation({ summary: 'Get all diagnostic test organ categories' })
  async getCategories() {
    const data = await this.testsService.getAllCategories();
    return {
      message: 'Test categories fetched successfully',
      data,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Get all diagnostic lab tests with category and search filters' })
  @ApiQuery({ name: 'category', required: false, type: String, description: 'Category slug e.g. bone, diabetes, heart' })
  @ApiQuery({ name: 'search', required: false, type: String, description: 'Keyword search query' })
  async getTests(
    @Query('category') category?: string,
    @Query('search') search?: string,
  ) {
    const data = await this.testsService.getAllTests({ category, search });
    return {
      message: 'Lab tests fetched successfully',
      data,
    };
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get diagnostic test details by slug' })
  async getTestBySlug(@Param('slug') slug: string) {
    const data = await this.testsService.getTestBySlug(slug);
    return {
      message: 'Lab test details fetched successfully',
      data,
    };
  }
}
