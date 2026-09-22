import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { SubscribeNewsletterDto } from './dto/subscribe-newsletter.dto';

@Injectable()
export class NewsletterService {
  constructor(private readonly prisma: PrismaService) {}

  async subscribe(dto: SubscribeNewsletterDto) {
    const existing = await this.prisma.newsletterSubscriber.findUnique({
      where: { email: dto.email.toLowerCase().trim() },
    });

    if (existing) {
      return { message: 'You are already subscribed to our newsletter!', data: existing };
    }

    const subscriber = await this.prisma.newsletterSubscriber.create({
      data: { email: dto.email.toLowerCase().trim() },
    });

    return { message: 'Thank you for subscribing to Pathogo updates!', data: subscriber };
  }
}
