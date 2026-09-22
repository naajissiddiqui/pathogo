import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { AllExceptionsFilter } from './common/filters/http-exception.filter';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);

  app.setGlobalPrefix('api');

  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: false,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  app.useGlobalInterceptors(new TransformInterceptor());
  app.useGlobalFilters(new AllExceptionsFilter());

  const config = new DocumentBuilder()
    .setTitle('Pathogo Diagnostics & Healthcare API')
    .setDescription(
      'REST API documentation for Pathogo healthcare platform — Authentication, User Management, Diagnostic Packages, Lab Tests, Specialists, Home Sample Bookings & Doctor Appointments.',
    )
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .addTag('Auth', 'User registration, login, and profile authentication')
    .addTag('Users', 'User management and patient directory')
    .addTag('Packages', 'Health packages and wellness profiles')
    .addTag('Lab Tests', 'Diagnostic tests and organ categories')
    .addTag('Doctors & Specialists', 'Medical specialists and consultation slots')
    .addTag('Test Bookings', 'Home collection & lab test bookings')
    .addTag('Doctor Appointments', 'Doctor consultation appointments')
    .addTag('Reviews', 'Verified patient testimonials')
    .addTag('Lab Partners', 'Certified diagnostic partners')
    .addTag('Newsletter', 'Subscriber email management')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 4000;
  await app.listen(port);
  logger.log(`🚀 Pathogo Backend running at: http://localhost:${port}/api`);
  logger.log(`📚 Swagger Documentation at: http://localhost:${port}/api/docs`);
}

bootstrap();
