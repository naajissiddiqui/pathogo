import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiResponse as SwaggerResponse } from '@nestjs/swagger';
import { PackagesService } from './packages.service';

@ApiTags('Packages')
@Controller('packages')
export class PackagesController {
  constructor(private readonly packagesService: PackagesService) {}

  @Get('categories')
  @ApiOperation({ summary: 'Get all package categories' })
  async getCategories() {
    const data = await this.packagesService.getAllCategories();
    return {
      message: 'Package categories fetched successfully',
      data,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Get all health packages with optional category and search filters' })
  @ApiQuery({ name: 'category', required: false, type: String, description: 'Category slug e.g. basic, women, men' })
  @ApiQuery({ name: 'search', required: false, type: String, description: 'Keyword search query' })
  @ApiQuery({ name: 'popular', required: false, type: Boolean, description: 'Filter popular packages' })
  async getPackages(
    @Query('category') category?: string,
    @Query('search') search?: string,
    @Query('popular') popular?: string,
  ) {
    const data = await this.packagesService.getAllPackages({
      category,
      search,
      popular: popular === 'true',
    });
    return {
      message: 'Health packages fetched successfully',
      data,
    };
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get health package details by slug' })
  async getPackageBySlug(@Param('slug') slug: string) {
    const data = await this.packagesService.getPackageBySlug(slug);
    return {
      message: 'Health package details fetched successfully',
      data,
    };
  }
}
