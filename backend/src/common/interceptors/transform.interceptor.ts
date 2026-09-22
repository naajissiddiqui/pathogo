import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { ApiResponse } from '../dto/api-response.dto';

@Injectable()
export class TransformInterceptor<T>
  implements NestInterceptor<T, ApiResponse<T>>
{
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<ApiResponse<T>> {
    return next.handle().pipe(
      map((res) => {
        if (res && typeof res === 'object' && 'data' in res && 'message' in res) {
          return {
            success: res.success !== undefined ? res.success : true,
            message: res.message,
            data: res.data,
            timestamp: new Date().toISOString(),
          };
        }

        return {
          success: true,
          message: 'Request processed successfully',
          data: res,
          timestamp: new Date().toISOString(),
        };
      }),
    );
  }
}
