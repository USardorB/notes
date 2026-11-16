// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_local_dao.dart';

// ignore_for_file: type=lint
mixin _$AuthLocalDaoMixin on DatabaseAccessor<AppDatabase> {
  $AuthSessionsTable get authSessions => attachedDatabase.authSessions;
  AuthLocalDaoManager get managers => AuthLocalDaoManager(this);
}

class AuthLocalDaoManager {
  final _$AuthLocalDaoMixin _db;
  AuthLocalDaoManager(this._db);
  $$AuthSessionsTableTableManager get authSessions =>
      $$AuthSessionsTableTableManager(_db.attachedDatabase, _db.authSessions);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authLocalDao)
final authLocalDaoProvider = AuthLocalDaoProvider._();

final class AuthLocalDaoProvider
    extends $FunctionalProvider<AuthLocalDao, AuthLocalDao, AuthLocalDao>
    with $Provider<AuthLocalDao> {
  AuthLocalDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalDaoHash();

  @$internal
  @override
  $ProviderElement<AuthLocalDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthLocalDao create(Ref ref) {
    return authLocalDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocalDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocalDao>(value),
    );
  }
}

String _$authLocalDaoHash() => r'3a4e73631b80348bfa95f215802bb5450adbffdf';
