import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

describe('AuthService', () => {
  let authService: AuthService;
  let usersService: Partial<UsersService>;
  let jwtService: Partial<JwtService>;

  beforeEach(async () => {
    usersService = {
      create: jest.fn().mockImplementation((dto) =>
        Promise.resolve({
          id: 'usr-test-1',
          name: dto.name,
          email: dto.email,
          phone: dto.phone,
          createdAt: new Date(),
          updatedAt: new Date(),
        }),
      ),
      findByEmailWithPassword: jest.fn().mockImplementation(async (email) => {
        if (email === 'rahul@pathogo.com') {
          const hashedPassword = await bcrypt.hash('Password123!', 10);
          return {
            id: 'usr-test-1',
            name: 'Rahul Sharma',
            email: 'rahul@pathogo.com',
            phone: '9876543210',
            password: hashedPassword,
          };
        }
        return null;
      }),
      findOne: jest.fn().mockResolvedValue({
        id: 'usr-test-1',
        name: 'Rahul Sharma',
        email: 'rahul@pathogo.com',
        phone: '9876543210',
      }),
    };

    jwtService = {
      sign: jest.fn().mockReturnValue('mock_jwt_token_sample_abc123'),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: UsersService, useValue: usersService },
        { provide: JwtService, useValue: jwtService },
      ],
    }).compile();

    authService = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(authService).toBeDefined();
  });

  it('should register a new user and return JWT token', async () => {
    const result = await authService.register({
      name: 'Priya Verma',
      email: 'priya@example.com',
      phone: '9812345678',
      password: 'Password123!',
    });

    expect(result).toHaveProperty('token', 'mock_jwt_token_sample_abc123');
    expect(result.user.name).toEqual('Priya Verma');
  });

  it('should login valid user successfully', async () => {
    const result = await authService.login({
      email: 'rahul@pathogo.com',
      password: 'Password123!',
    });

    expect(result).toHaveProperty('token', 'mock_jwt_token_sample_abc123');
    expect(result.user.email).toEqual('rahul@pathogo.com');
  });

  it('should throw error on invalid credentials', async () => {
    await expect(
      authService.login({
        email: 'rahul@pathogo.com',
        password: 'WrongPassword!',
      }),
    ).rejects.toThrow();
  });
});
