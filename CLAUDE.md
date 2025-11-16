# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Afya is a medicine management system with a Spring Boot backend API and Flutter mobile frontend. The system enables users to manage medications through pharmacy boxes, track purchase history, and collaborate via groups (family/healthcare teams).

**Important**: This is a monorepo containing two separate applications. Each subdirectory has its own CLAUDE.md with detailed instructions:
- `back-end/CLAUDE.md` - Spring Boot API specifics
- `flutter_mobile/CLAUDE.md` - Flutter app specifics

## Quick Start

### Backend (Spring Boot)
```bash
cd back-end
./mvnw spring-boot:run  # Starts on http://localhost:8081
```
Swagger UI: http://localhost:8081/swagger-ui/index.html

### Frontend (Flutter)
```bash
cd flutter_mobile
flutter pub get
flutter run
```

**Critical**: The Flutter app connects to the backend via the URL configured in `flutter_mobile/lib/core/constants/api_endpoint.dart`. Update this when switching between development (ngrok) and production environments.

## Development Workflow

### Making Backend Changes
1. Modify Java code in `back-end/src/main/java/com/idvey/afya/`
2. Run `./mvnw spring-javaformat:apply` (formatting is enforced by Maven)
3. Test with `./mvnw test` or `./mvnw test -Dtest=ClassName`
4. Restart: `./mvnw spring-boot:run`

### Making Frontend Changes
1. Modify Dart code in `flutter_mobile/lib/`
2. Hot reload: Press `r` (fast, preserves state)
3. Hot restart: Press `R` (full restart)
4. Check issues: `flutter analyze`

### Full-Stack Feature Development
When adding a new feature that spans both backend and frontend:

1. **Backend First**:
   - Add entity in `models/`
   - Create repository in `repository/`
   - Create service in `security/service/`
   - Create controller in `controllers/` with DTOs in `payload/`
   - Format: `./format.sh`
   - Test endpoint via Swagger UI

2. **Frontend Second**:
   - Create entity in `domain/entities/`
   - Create model in `data/model/`
   - Create repository interface in `domain/repositories/`
   - Implement repository in `data/repositories/`
   - Create data source in `data/data_sources/`
   - Create cubit in `presentation/bloc/`
   - Create UI in `presentation/screens/`
   - Register dependencies in `injection_container.dart`
   - Add route in `config/router/app_route.dart`

## Architecture

### System Components
1. **Flutter Mobile App** (Android/iOS) - Clean Architecture with BLoC pattern
2. **Spring Boot API** (Port 8081) - RESTful API with JWT authentication
3. **MariaDB/MySQL** (Port 3306) - Relational database

### Backend Architecture
- **Controllers**: REST endpoints (`controllers/`)
- **Services**: Business logic (`security/service/`)
- **Repositories**: Data access (`repository/`)
- **Models**: JPA entities (`models/`)
- **Security**: JWT + refresh tokens, group-based authorization, rate limiting (100 req/min/IP)

### Frontend Architecture (Clean Architecture)
- **Domain**: Business logic (entities, repository interfaces)
- **Data**: Implementation (models, data sources, repository implementations)
- **Presentation**: UI (BLoC/Cubit, screens, widgets)

**Dependency Flow**: Presentation → Domain ← Data (domain has no dependencies on outer layers)

### Key Domain Concepts
- **Groups**: Collaboration units with roles (MANAGER, RESPONSIBLE, MEMBER)
- **Pharmacy Boxes**: Medicine containers linked to groups
- **Medicines**: Master medicine database with barcode support
- **My Medicines**: Personal medicine instances in pharmacy boxes
- **Purchase History**: Purchase/consumption tracking with expiry monitoring
- **Prescriptions/Treatments/Reminders**: Medical management features
- **Group Medical**: Family member medical data management

### Authentication Flow
1. **Onboarding** (first time) → stored in SharedPreferences
2. **Sign Up** → email sent with activation code
3. **Account Verification** → OTP verification
4. **Sign In** → JWT + refresh token returned
5. **Token Storage** → SharedPreferences (access + refresh tokens)
6. **Auto-refresh** → AuthInterceptor handles token refresh automatically
7. **Network Monitoring** → AuthBloc monitors connectivity, shows alerts

## Environment Configuration

### Backend Environment Variables
- `SECRET_KEY`: JWT signing secret (required for production)
- Database credentials: Override via environment variables

### Frontend API Endpoint
**Location**: `flutter_mobile/lib/core/constants/api_endpoint.dart`

```dart
static const String baseurl = "YOUR_API_URL/api";
```

- **Development**: Use ngrok tunnel URL (e.g., `https://xxxxx.ngrok-free.app/api`)
- **Production**: Use direct VPS URL (`http://102.219.178.221:8081/api`)

**Important**: After changing the endpoint, do a hot restart (R) in Flutter, not just hot reload.

## Deployment

### Production Environment
- **Provider**: OxaHost VPS (srv203017)
- **Server**: Ubuntu 20.04.6 LTS
- **IP**: 102.219.178.221
- **App Port**: 8081 (8085 in production config)
- **Web Access**: Port 80 via Nginx reverse proxy

### Quick Deploy
```bash
# Build locally
cd back-end && ./mvnw clean package -DskipTests

# Upload to VPS
scp target/afya-0.0.1-SNAPSHOT.jar root@102.219.178.221:/opt/afya/afya.jar

# Restart service
ssh root@102.219.178.221
systemctl restart afya
```

See `complete_deployment_guide.md` for full deployment instructions.

## Security Notes

### Backend
- All endpoints require JWT except: `/api/auth/**`, `/swagger-ui/**`, `/actuator/health`
- Group-based authorization: Users only access their group's data
- BCrypt password hashing
- Rate limiting: 100 requests/minute per IP
- CORS: Enabled for all origins (development config - restrict in production)

### Frontend
- Tokens stored in SharedPreferences (consider flutter_secure_storage for production)
- Auto token refresh via AuthInterceptor
- Network status monitoring via AuthBloc
- Device info tracking for sessions

## Testing

### Backend
```bash
cd back-end
./mvnw test                    # All tests
./mvnw test -Dtest=ClassName   # Specific test
```

### Frontend
```bash
cd flutter_mobile
flutter test                   # All tests
flutter analyze               # Static analysis
```

## Important Files

### Configuration
- Backend: `back-end/src/main/resources/application.properties`
- Flutter dependencies: `flutter_mobile/pubspec.yaml`
- API endpoint: `flutter_mobile/lib/core/constants/api_endpoint.dart`

### Logs and Uploads
- **Local**: `back-end/logs/`, `back-end/uploads/`
- **Production**: `/opt/afya/logs/`, `/opt/afya/uploads/`

## Common Issues

### Backend won't start
- Check MariaDB is running on port 3306
- Verify `SECRET_KEY` environment variable is set
- Check port 8081 is not already in use

### Flutter can't connect to API
- Verify API endpoint in `api_endpoint.dart` is correct
- For ngrok: Ensure ngrok is running and URL is updated
- Check CORS configuration in backend
- Hot restart (R) after changing API endpoint

### Code formatting errors
- Backend: Run `./mvnw spring-javaformat:apply` before building
- Formatting is enforced by Maven - build will fail if code is not formatted

## Additional Resources

- Spring Boot: https://spring.io/projects/spring-boot
- Flutter: https://docs.flutter.dev/
- BLoC Pattern: https://bloclibrary.dev/
- Backend README: `back-end/README.md`
- Deployment Guide: `complete_deployment_guide.md`
