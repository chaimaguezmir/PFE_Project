# Afya Medicine Management System

A comprehensive medicine management system built with Spring Boot that allows users to manage their medications through pharmacy boxes, track purchase history, and collaborate with groups.

## 🚀 Features

### Authentication & Security
- **JWT-based authentication** with refresh tokens
- **Email verification** with activation codes
- **Password reset** functionality
- **Device-specific** session management
- **Role-based access control**

### Group Management
- **Create and manage groups** for family or healthcare teams
- **Role-based permissions** (Manager, Responsible, Member)
- **Group collaboration** for shared medicine management
- **Automatic default group** creation

### Pharmacy Box System
- **Personal medicine containers** linked to groups
- **Secure access control** - only group members can access
- **Medicine inventory tracking** with counts
- **Multiple pharmacy boxes** per user

### Medicine Management
- **Master medicine database** with search capabilities
- **Personal medicine tracking** with custom names and forms
- **Barcode support** for quick medicine identification
- **Advanced search** by name, manufacturer, dosage form
- **Prescription vs OTC** classification

### Purchase History
- **Track medicine purchases** and consumption
- **Expiry date monitoring** and alerts
- **Quantity tracking** over time
- **Purchase analytics** and reporting
- **Date range filtering** for historical data

## 🛠️ Technology Stack

- **Backend**: Spring Boot 3.4.5
- **Database**: MariaDB (configurable to PostgreSQL)
- **Security**: Spring Security with JWT
- **Documentation**: Swagger/OpenAPI 3
- **Email**: Spring Mail with Thymeleaf templates
- **Build Tool**: Maven
- **Java Version**: 17

## 📋 Prerequisites

- Java 17 or higher
- Maven 3.6+
- MariaDB 10.4+ (or PostgreSQL)
- SMTP server for email functionality

## 🔧 Installation

### 1. Clone the repository
```bash
git clone https://github.com/your-username/afya-medicine-system.git
cd afya-medicine-system
```
### 2. Run the Application
```bash
./mvnw spring-boot:run
```

The application will start on `http://localhost:8081`

## 📚 API Documentation

### Swagger UI
Access the interactive API documentation at:
```
http://localhost:8081/swagger-ui/index.html
```

### API Endpoints Overview

#### Authentication
- `POST /api/auth/signup` - User registration
- `POST /api/auth/signin` - User login
- `POST /api/auth/refreshtoken` - Refresh JWT token
- `POST /api/auth/signout` - User logout

#### Groups
- `GET /api/groups` - Get user's groups
- `POST /api/groups` - Create new group
- `POST /api/groups/{id}/members` - Add member to group
- `DELETE /api/groups/{id}` - Delete group

#### Pharmacy Boxes
- `GET /api/pharmacy-box/mine` - Get user's pharmacy boxes

#### Medicines
- `GET /api/medicines` - Get all medicines
- `POST /api/medicines` - Create new medicine
- `GET /api/medicines/search?q={query}` - Search medicines
- `GET /api/medicines/barcode/{barcode}` - Find by barcode

#### My Medicines
- `POST /api/my-medicines` - Add medicine to pharmacy box
- `GET /api/my-medicines/pharmacy-box/{id}` - Get medicines in pharmacy box
- `PUT /api/my-medicines/{id}` - Update medicine
- `DELETE /api/my-medicines/{id}` - Remove medicine

#### Purchase History
- `POST /api/purchase-history` - Record purchase
- `GET /api/purchase-history/my-medicine/{id}` - Get purchase history
- `GET /api/purchase-history/expired` - Get expired purchases

## 🧪 Testing

### Run Unit Tests
```bash
./mvnw test
```

### Postman Collection
Import the provided Postman collection for comprehensive API testing:
1. Open Postman
2. Import the collection JSON file
3. Set environment variable `baseUrl` to `http://localhost:8081`
4. Run the collection to test all endpoints

## 🔒 Security Features

- **JWT Authentication** with configurable expiration
- **Refresh Token** system for extended sessions
- **Group-based authorization** - users can only access their group's data
- **Email verification** required for account activation
- **Password reset** with time-limited codes
- **Device tracking** for session management

## 📊 Database Schema

The system uses the following main entities:
- **User** - User account information
- **Group** - Collaboration groups
- **PharmacyBox** - Medicine containers
- **Medicine** - Master medicine database
- **MyMedicine** - User's personal medicines
- **MedicinePurchaseHistory** - Purchase/consumption records

## 🚀 Deployment

### Using Docker (Optional)
```dockerfile
FROM openjdk:17-jdk-slim
COPY target/afya-*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### Environment Variables
Set these environment variables in production:
```bash
SPRING_DATASOURCE_URL=jdbc:mariadb://your-db-host:3306/afya
SPRING_DATASOURCE_USERNAME=your-db-user
SPRING_DATASOURCE_PASSWORD=your-db-password
AFYA_APP_JWT_SECRET=your-production-secret
SPRING_MAIL_USERNAME=your-email@domain.com
SPRING_MAIL_PASSWORD=your-email-password
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Your Name** - *Initial work* - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Spring Boot team for the excellent framework
- Swagger team for API documentation tools
- MariaDB team for the reliable database system

## 📞 Support

For support, email support@afya.com or create an issue in this repository.

---

**Happy Medicine Management! 💊**