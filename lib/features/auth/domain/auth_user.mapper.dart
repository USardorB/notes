// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_user.dart';

class AuthUserMapper extends ClassMapperBase<AuthUser> {
  AuthUserMapper._();

  static AuthUserMapper? _instance;
  static AuthUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthUser';

  static String _$id(AuthUser v) => v.id;
  static const Field<AuthUser, String> _f$id = Field('id', _$id);
  static String _$email(AuthUser v) => v.email;
  static const Field<AuthUser, String> _f$email = Field('email', _$email);
  static String _$displayName(AuthUser v) => v.displayName;
  static const Field<AuthUser, String> _f$displayName = Field(
    'displayName',
    _$displayName,
  );
  static String _$accessToken(AuthUser v) => v.accessToken;
  static const Field<AuthUser, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
  );
  static SyncStatus _$syncStatus(AuthUser v) => v.syncStatus;
  static const Field<AuthUser, SyncStatus> _f$syncStatus = Field(
    'syncStatus',
    _$syncStatus,
    opt: true,
    def: SyncStatus.synced,
  );

  @override
  final MappableFields<AuthUser> fields = const {
    #id: _f$id,
    #email: _f$email,
    #displayName: _f$displayName,
    #accessToken: _f$accessToken,
    #syncStatus: _f$syncStatus,
  };

  static AuthUser _instantiate(DecodingData data) {
    return AuthUser(
      id: data.dec(_f$id),
      email: data.dec(_f$email),
      displayName: data.dec(_f$displayName),
      accessToken: data.dec(_f$accessToken),
      syncStatus: data.dec(_f$syncStatus),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthUser>(map);
  }

  static AuthUser fromJson(String json) {
    return ensureInitialized().decodeJson<AuthUser>(json);
  }
}

mixin AuthUserMappable {
  String toJson() {
    return AuthUserMapper.ensureInitialized().encodeJson<AuthUser>(
      this as AuthUser,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthUserMapper.ensureInitialized().encodeMap<AuthUser>(
      this as AuthUser,
    );
  }

  AuthUserCopyWith<AuthUser, AuthUser, AuthUser> get copyWith =>
      _AuthUserCopyWithImpl<AuthUser, AuthUser>(
        this as AuthUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthUserMapper.ensureInitialized().stringifyValue(this as AuthUser);
  }

  @override
  bool operator ==(Object other) {
    return AuthUserMapper.ensureInitialized().equalsValue(
      this as AuthUser,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthUserMapper.ensureInitialized().hashValue(this as AuthUser);
  }
}

extension AuthUserValueCopy<$R, $Out> on ObjectCopyWith<$R, AuthUser, $Out> {
  AuthUserCopyWith<$R, AuthUser, $Out> get $asAuthUser =>
      $base.as((v, t, t2) => _AuthUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthUserCopyWith<$R, $In extends AuthUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? email,
    String? displayName,
    String? accessToken,
    SyncStatus? syncStatus,
  });
  AuthUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthUser, $Out>
    implements AuthUserCopyWith<$R, AuthUser, $Out> {
  _AuthUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthUser> $mapper =
      AuthUserMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? email,
    String? displayName,
    String? accessToken,
    SyncStatus? syncStatus,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (email != null) #email: email,
      if (displayName != null) #displayName: displayName,
      if (accessToken != null) #accessToken: accessToken,
      if (syncStatus != null) #syncStatus: syncStatus,
    }),
  );
  @override
  AuthUser $make(CopyWithData data) => AuthUser(
    id: data.get(#id, or: $value.id),
    email: data.get(#email, or: $value.email),
    displayName: data.get(#displayName, or: $value.displayName),
    accessToken: data.get(#accessToken, or: $value.accessToken),
    syncStatus: data.get(#syncStatus, or: $value.syncStatus),
  );

  @override
  AuthUserCopyWith<$R2, AuthUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginRequestMapper extends ClassMapperBase<LoginRequest> {
  LoginRequestMapper._();

  static LoginRequestMapper? _instance;
  static LoginRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginRequest';

  static String _$email(LoginRequest v) => v.email;
  static const Field<LoginRequest, String> _f$email = Field('email', _$email);
  static String _$password(LoginRequest v) => v.password;
  static const Field<LoginRequest, String> _f$password = Field(
    'password',
    _$password,
  );

  @override
  final MappableFields<LoginRequest> fields = const {
    #email: _f$email,
    #password: _f$password,
  };

  static LoginRequest _instantiate(DecodingData data) {
    return LoginRequest(
      email: data.dec(_f$email),
      password: data.dec(_f$password),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginRequest>(map);
  }

  static LoginRequest fromJson(String json) {
    return ensureInitialized().decodeJson<LoginRequest>(json);
  }
}

mixin LoginRequestMappable {
  String toJson() {
    return LoginRequestMapper.ensureInitialized().encodeJson<LoginRequest>(
      this as LoginRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginRequestMapper.ensureInitialized().encodeMap<LoginRequest>(
      this as LoginRequest,
    );
  }

  LoginRequestCopyWith<LoginRequest, LoginRequest, LoginRequest> get copyWith =>
      _LoginRequestCopyWithImpl<LoginRequest, LoginRequest>(
        this as LoginRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginRequestMapper.ensureInitialized().stringifyValue(
      this as LoginRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginRequestMapper.ensureInitialized().equalsValue(
      this as LoginRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginRequestMapper.ensureInitialized().hashValue(
      this as LoginRequest,
    );
  }
}

extension LoginRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginRequest, $Out> {
  LoginRequestCopyWith<$R, LoginRequest, $Out> get $asLoginRequest =>
      $base.as((v, t, t2) => _LoginRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginRequestCopyWith<$R, $In extends LoginRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password});
  LoginRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginRequest, $Out>
    implements LoginRequestCopyWith<$R, LoginRequest, $Out> {
  _LoginRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginRequest> $mapper =
      LoginRequestMapper.ensureInitialized();
  @override
  $R call({String? email, String? password}) => $apply(
    FieldCopyWithData({
      if (email != null) #email: email,
      if (password != null) #password: password,
    }),
  );
  @override
  LoginRequest $make(CopyWithData data) => LoginRequest(
    email: data.get(#email, or: $value.email),
    password: data.get(#password, or: $value.password),
  );

  @override
  LoginRequestCopyWith<$R2, LoginRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RegisterRequestMapper extends ClassMapperBase<RegisterRequest> {
  RegisterRequestMapper._();

  static RegisterRequestMapper? _instance;
  static RegisterRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RegisterRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RegisterRequest';

  static String _$id(RegisterRequest v) => v.id;
  static const Field<RegisterRequest, String> _f$id = Field('id', _$id);
  static String _$displayName(RegisterRequest v) => v.displayName;
  static const Field<RegisterRequest, String> _f$displayName = Field(
    'displayName',
    _$displayName,
  );
  static String _$email(RegisterRequest v) => v.email;
  static const Field<RegisterRequest, String> _f$email = Field(
    'email',
    _$email,
  );
  static String _$password(RegisterRequest v) => v.password;
  static const Field<RegisterRequest, String> _f$password = Field(
    'password',
    _$password,
  );

  @override
  final MappableFields<RegisterRequest> fields = const {
    #id: _f$id,
    #displayName: _f$displayName,
    #email: _f$email,
    #password: _f$password,
  };

  static RegisterRequest _instantiate(DecodingData data) {
    return RegisterRequest(
      id: data.dec(_f$id),
      displayName: data.dec(_f$displayName),
      email: data.dec(_f$email),
      password: data.dec(_f$password),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RegisterRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RegisterRequest>(map);
  }

  static RegisterRequest fromJson(String json) {
    return ensureInitialized().decodeJson<RegisterRequest>(json);
  }
}

mixin RegisterRequestMappable {
  String toJson() {
    return RegisterRequestMapper.ensureInitialized()
        .encodeJson<RegisterRequest>(this as RegisterRequest);
  }

  Map<String, dynamic> toMap() {
    return RegisterRequestMapper.ensureInitialized().encodeMap<RegisterRequest>(
      this as RegisterRequest,
    );
  }

  RegisterRequestCopyWith<RegisterRequest, RegisterRequest, RegisterRequest>
  get copyWith =>
      _RegisterRequestCopyWithImpl<RegisterRequest, RegisterRequest>(
        this as RegisterRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RegisterRequestMapper.ensureInitialized().stringifyValue(
      this as RegisterRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return RegisterRequestMapper.ensureInitialized().equalsValue(
      this as RegisterRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return RegisterRequestMapper.ensureInitialized().hashValue(
      this as RegisterRequest,
    );
  }
}

extension RegisterRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RegisterRequest, $Out> {
  RegisterRequestCopyWith<$R, RegisterRequest, $Out> get $asRegisterRequest =>
      $base.as((v, t, t2) => _RegisterRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RegisterRequestCopyWith<$R, $In extends RegisterRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? displayName, String? email, String? password});
  RegisterRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RegisterRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RegisterRequest, $Out>
    implements RegisterRequestCopyWith<$R, RegisterRequest, $Out> {
  _RegisterRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RegisterRequest> $mapper =
      RegisterRequestMapper.ensureInitialized();
  @override
  $R call({String? id, String? displayName, String? email, String? password}) =>
      $apply(
        FieldCopyWithData({
          if (id != null) #id: id,
          if (displayName != null) #displayName: displayName,
          if (email != null) #email: email,
          if (password != null) #password: password,
        }),
      );
  @override
  RegisterRequest $make(CopyWithData data) => RegisterRequest(
    id: data.get(#id, or: $value.id),
    displayName: data.get(#displayName, or: $value.displayName),
    email: data.get(#email, or: $value.email),
    password: data.get(#password, or: $value.password),
  );

  @override
  RegisterRequestCopyWith<$R2, RegisterRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RegisterRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

