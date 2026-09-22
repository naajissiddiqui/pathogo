import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ReviewsService } from './reviews.service';

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Get()
  @ApiOperation({ summary: 'Get verified patient testimonials' })
  async getReviews() {
    const data = await this.reviewsService.getAllReviews();
    return {
      message: 'Reviews fetched successfully',
      data,
    };
  }
}
