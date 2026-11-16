import 'package:dart_mappable/dart_mappable.dart';

part 'auth_user.mapper.dart';

/// ============================================================================
/// ARCHITECTURAL NOTE — Unified Domain Model with Dart Primary Constructors
/// ============================================================================
/// 1. Avoiding Mapper Bloat:
///    In classic Uncle Bob Clean Architecture, you would create `AuthUserEntity`,
///    `AuthUserDto`, `AuthUserLocalModel`, and manual mapper classes. When the
///    domain and API schemas align, `@MappableClass()` generates `copyWith`,
///    `==`, `hashCode`, `toString`, `toMap()`, and `toJson()` in one place.
///
/// 2. Dart Primary Constructors + Global Retrofit Parser (PR #939):
///    Using Dart's primary constructor syntax (`class AuthUser(...) with ...;`)
///    combined with `parser: dart_mappable` in `build.yaml`, the entire data
///    class is declared in a single concise header without field duplication
///    or boilerplate `fromJson`/`toJson` factories!
@MappableClass()
class AuthUser({
  required final String id,
  required final String email,
  required final String displayName,
  required final String accessToken,
}) with AuthUserMappable;

/// Request payload for `POST /auth/login`.
@MappableClass()
class LoginRequest({
  required final String email,
  required final String password,
}) with LoginRequestMappable;

/// Request payload for `POST /auth/register`.
@MappableClass()
class RegisterRequest({
  required final String displayName,
  required final String email,
  required final String password,
}) with RegisterRequestMappable;
