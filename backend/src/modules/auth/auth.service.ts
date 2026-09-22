import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const user = await this.usersService.create(dto);
    const token = this.generateToken(user.id, user.email);

    return {
      token,
      user,
    };
  }

  async login(dto: LoginDto) {
    const userWithPassword = await this.usersService.findByEmailWithPassword(
      dto.email,
    );

    if (!userWithPassword) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isMatch = await bcrypt.compare(
      dto.password,
      userWithPassword.password,
    );

    if (!isMatch) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const { password, ...safeUser } = userWithPassword;
    const token = this.generateToken(safeUser.id, safeUser.email);

    return {
      token,
      user: safeUser,
    };
  }

  async getProfile(userId: string) {
    return this.usersService.findOne(userId);
  }

  private generateToken(userId: string, email: string): string {
    const payload = { sub: userId, email };
    return this.jwtService.sign(payload);
  }
}
