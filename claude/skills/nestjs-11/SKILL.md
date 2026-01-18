---
name: nestjs-11
description: >
  NestJS 11 patterns and best practices.
  Trigger: When working with NestJS - controllers, services, modules, DTOs.
license: MIT
metadata:
  author: aristeoibarra
  version: "1.0"
---

## Module Structure

```
src/
├── app.module.ts
├── main.ts
└── users/
    ├── users.module.ts
    ├── users.controller.ts
    ├── users.service.ts
    ├── dto/
    │   ├── create-user.dto.ts
    │   └── update-user.dto.ts
    └── entities/
        └── user.entity.ts
```

## Modules

```typescript
import { Module } from "@nestjs/common";
import { UsersController } from "./users.controller";
import { UsersService } from "./users.service";

@Module({
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService], // Only if other modules need it
})
export class UsersModule {}
```

## Controllers

```typescript
import { Controller, Get, Post, Body, Param, Delete, Put } from "@nestjs/common";
import { UsersService } from "./users.service";
import { CreateUserDto } from "./dto/create-user.dto";

@Controller("users")
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.usersService.findOne(id);
  }

  @Put(":id")
  update(@Param("id") id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(":id")
  remove(@Param("id") id: string) {
    return this.usersService.remove(id);
  }
}
```

## Services

```typescript
import { Injectable, NotFoundException } from "@nestjs/common";

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    return this.prisma.user.create({ data: createUserDto });
  }

  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) throw new NotFoundException(`User ${id} not found`);
    return user;
  }
}
```

## DTOs with class-validator

```typescript
import { IsEmail, IsString, MinLength, IsOptional } from "class-validator";

export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(2)
  name: string;

  @IsString()
  @MinLength(8)
  password: string;
}

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @MinLength(2)
  name?: string;
}
```

## Global ValidationPipe

```typescript
// main.ts
import { ValidationPipe } from "@nestjs/common";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,        // Strip unknown properties
      forbidNonWhitelisted: true,  // Throw on unknown properties
      transform: true,        // Auto-transform payloads to DTO instances
    })
  );

  await app.listen(3000);
}
```

## Guards (Auth)

```typescript
import { Injectable, CanActivate, ExecutionContext } from "@nestjs/common";

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    return this.validateRequest(request);
  }

  private validateRequest(request: any): boolean {
    return !!request.headers.authorization;
  }
}

// Usage
@UseGuards(AuthGuard)
@Get("profile")
getProfile() {}
```

## Exception Handling

```typescript
// ✅ Use NestJS built-in exceptions
throw new NotFoundException("User not found");
throw new BadRequestException("Invalid input");
throw new UnauthorizedException("Invalid credentials");
throw new ForbiddenException("Access denied");
throw new ConflictException("Email already exists");

// ❌ NEVER: Generic errors
throw new Error("Something went wrong");
```

## Decorators

```typescript
// Custom decorator
import { createParamDecorator, ExecutionContext } from "@nestjs/common";

export const CurrentUser = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  }
);

// Usage
@Get("me")
getMe(@CurrentUser() user: User) {
  return user;
}
```

## Interceptors

```typescript
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from "@nestjs/common";
import { map } from "rxjs/operators";

@Injectable()
export class TransformInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler) {
    return next.handle().pipe(
      map(data => ({ data, timestamp: new Date().toISOString() }))
    );
  }
}
```

## Config with @nestjs/config

```typescript
// app.module.ts
import { ConfigModule } from "@nestjs/config";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ".env",
    }),
  ],
})
export class AppModule {}

// Usage in service
constructor(private config: ConfigService) {
  const dbUrl = this.config.get<string>("DATABASE_URL");
}
```

## Quick Commands

```bash
# Generate resources
nest g resource users      # Full CRUD module
nest g module users        # Module only
nest g controller users    # Controller only
nest g service users       # Service only

# Run
npm run start:dev          # Development with watch
npm run start:debug        # Debug mode
npm run build && npm run start:prod  # Production
```
