---
name: java-springboot
description: General Spring Boot architecture guidelines — package-by-feature, configuration, DTOs, API design, error handling and testing best practices
license: MIT
compatibility: opencode
metadata:
  domain: java-springboot
  style: guidelines
---

# Spring Boot Architecture Guidelines

## Philosophy

Prioritize:

- readability over cleverness
- maintainability over premature optimization
- explicitness over magic
- simplicity over unnecessary abstractions
- modern Spring Boot best practices

Every architectural decision should make future evolution easier.

---

# General Principles

## Single Responsibility Principle

Each class should have one responsibility.

Examples:

- Controller → expose HTTP endpoints
- Service → business logic
- Repository → persistence
- Configuration → infrastructure
- DTO → API contract

---

## Constructor Injection

Always prefer constructor injection.

Never use field injection (`@Autowired` on fields).

Good:

```java
public UserController(UserService userService) {
    this.userService = userService;
}
```

---

## Immutability

Whenever possible, prefer immutable objects.

Configuration classes should use Java records.

DTOs should generally use records.

Mutable state should stay inside services or domain entities only.

---

# Configuration

## Never hardcode configuration

Do not write:

```java
.allowedOrigins("https://app.example.com")
```

Configuration belongs in `application.yml`.

---

## Use @ConfigurationProperties

Do not use `@Value` except for isolated values.

Instead create typed configuration objects.

Example:

```yaml
app:
  cors:
    allowed-origins:
      - https://app.example.com
```

```java
@ConfigurationProperties(prefix = "app.cors")
public record CorsProperties(
    List<String> allowedOrigins
) {}
```

---

## Configuration scanning

Prefer

```java
@ConfigurationPropertiesScan
```

on the main Spring Boot application.

Avoid `@EnableConfigurationProperties` unless there is a specific reason.

---

# Package organization

Organize code **by feature**, not by technical layer.

Each feature is self-contained under a feature package. A feature owns its
controller, service, repository, DTO, mapper and exceptions:

```
user/
    UserController.java
    UserService.java
    UserRepository.java
    UserDto.java
    UserMapper.java
    UserNotFoundException.java
```

Infrastructure shared across features stays in a dedicated package:

```
config/
```

Keep packages cohesive. Do not create generic `service/`, `dto/` or
`repository/` folders at the root — each feature owns its classes.

---

# Controllers

Controllers should:

- validate requests
- call services
- return DTOs

Controllers should **not** contain business logic.

---

# Services

Business rules belong here.

A service should not know anything about HTTP.

It should receive domain objects or DTOs and return domain objects or DTOs.

---

# Repositories

Repositories only access persistence.

No business logic.

---

# DTOs

Never expose JPA entities directly.

Use dedicated DTOs.

Prefer Java records.

Example:

```java
public record UserDto(
    Long id,
    String email,
    String displayName
) {}
```

---

# API Design

Endpoints should be RESTful.

Examples:

GET /api/users/{id}

POST /api/users

POST /api/orders

GET /api/orders/{id}

GET /api/stats

Avoid RPC-style endpoints.

---

# Error handling

Centralize exception handling.

Prefer:

```
@ControllerAdvice
```

Do not duplicate try/catch blocks inside controllers.

---

# Naming

Use meaningful names.

Good:

UserService

OrderController

PaymentRepository

Bad:

Utils

Manager

ServiceImpl

Data

---

# Testing

Business logic should be testable independently of Spring.

Keep services loosely coupled.

---

# Future evolution

The architecture should naturally support:

- authentication
- JWT
- WebSocket
- Redis
- statistics
- messaging

without major refactoring.

Always favor decisions that preserve this flexibility.
