// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ocr_controller.dart';

class OcrStateMapper extends ClassMapperBase<OcrState> {
  OcrStateMapper._();

  static OcrStateMapper? _instance;
  static OcrStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OcrStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'OcrState';

  static String? _$imagePath(OcrState v) => v.imagePath;
  static const Field<OcrState, String> _f$imagePath = Field(
    'imagePath',
    _$imagePath,
    opt: true,
  );
  static String? _$scannedText(OcrState v) => v.scannedText;
  static const Field<OcrState, String> _f$scannedText = Field(
    'scannedText',
    _$scannedText,
    opt: true,
  );
  static bool _$isScanning(OcrState v) => v.isScanning;
  static const Field<OcrState, bool> _f$isScanning = Field(
    'isScanning',
    _$isScanning,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<OcrState> fields = const {
    #imagePath: _f$imagePath,
    #scannedText: _f$scannedText,
    #isScanning: _f$isScanning,
  };

  static OcrState _instantiate(DecodingData data) {
    return OcrState(
      imagePath: data.dec(_f$imagePath),
      scannedText: data.dec(_f$scannedText),
      isScanning: data.dec(_f$isScanning),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OcrState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OcrState>(map);
  }

  static OcrState fromJson(String json) {
    return ensureInitialized().decodeJson<OcrState>(json);
  }
}

mixin OcrStateMappable {
  String toJson() {
    return OcrStateMapper.ensureInitialized().encodeJson<OcrState>(
      this as OcrState,
    );
  }

  Map<String, dynamic> toMap() {
    return OcrStateMapper.ensureInitialized().encodeMap<OcrState>(
      this as OcrState,
    );
  }

  OcrStateCopyWith<OcrState, OcrState, OcrState> get copyWith =>
      _OcrStateCopyWithImpl<OcrState, OcrState>(
        this as OcrState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return OcrStateMapper.ensureInitialized().stringifyValue(this as OcrState);
  }

  @override
  bool operator ==(Object other) {
    return OcrStateMapper.ensureInitialized().equalsValue(
      this as OcrState,
      other,
    );
  }

  @override
  int get hashCode {
    return OcrStateMapper.ensureInitialized().hashValue(this as OcrState);
  }
}

extension OcrStateValueCopy<$R, $Out> on ObjectCopyWith<$R, OcrState, $Out> {
  OcrStateCopyWith<$R, OcrState, $Out> get $asOcrState =>
      $base.as((v, t, t2) => _OcrStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OcrStateCopyWith<$R, $In extends OcrState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? imagePath, String? scannedText, bool? isScanning});
  OcrStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OcrStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OcrState, $Out>
    implements OcrStateCopyWith<$R, OcrState, $Out> {
  _OcrStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OcrState> $mapper =
      OcrStateMapper.ensureInitialized();
  @override
  $R call({
    Object? imagePath = $none,
    Object? scannedText = $none,
    bool? isScanning,
  }) => $apply(
    FieldCopyWithData({
      if (imagePath != $none) #imagePath: imagePath,
      if (scannedText != $none) #scannedText: scannedText,
      if (isScanning != null) #isScanning: isScanning,
    }),
  );
  @override
  OcrState $make(CopyWithData data) => OcrState(
    imagePath: data.get(#imagePath, or: $value.imagePath),
    scannedText: data.get(#scannedText, or: $value.scannedText),
    isScanning: data.get(#isScanning, or: $value.isScanning),
  );

  @override
  OcrStateCopyWith<$R2, OcrState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _OcrStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

