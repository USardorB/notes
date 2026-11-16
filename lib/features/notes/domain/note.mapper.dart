// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'note.dart';

class NoteTypeMapper extends EnumMapper<NoteType> {
  NoteTypeMapper._();

  static NoteTypeMapper? _instance;
  static NoteTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NoteTypeMapper._());
    }
    return _instance!;
  }

  static NoteType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NoteType decode(dynamic value) {
    switch (value) {
      case r'note':
        return NoteType.note;
      case r'todo':
        return NoteType.todo;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NoteType self) {
    switch (self) {
      case NoteType.note:
        return r'note';
      case NoteType.todo:
        return r'todo';
    }
  }
}

extension NoteTypeMapperExtension on NoteType {
  String toValue() {
    NoteTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NoteType>(this) as String;
  }
}

class TodoItemMapper extends ClassMapperBase<TodoItem> {
  TodoItemMapper._();

  static TodoItemMapper? _instance;
  static TodoItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TodoItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TodoItem';

  static String _$id(TodoItem v) => v.id;
  static const Field<TodoItem, String> _f$id = Field('id', _$id);
  static String _$text(TodoItem v) => v.text;
  static const Field<TodoItem, String> _f$text = Field('text', _$text);
  static bool _$isDone(TodoItem v) => v.isDone;
  static const Field<TodoItem, bool> _f$isDone = Field(
    'isDone',
    _$isDone,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<TodoItem> fields = const {
    #id: _f$id,
    #text: _f$text,
    #isDone: _f$isDone,
  };

  static TodoItem _instantiate(DecodingData data) {
    return TodoItem(
      id: data.dec(_f$id),
      text: data.dec(_f$text),
      isDone: data.dec(_f$isDone),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TodoItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TodoItem>(map);
  }

  static TodoItem fromJson(String json) {
    return ensureInitialized().decodeJson<TodoItem>(json);
  }
}

mixin TodoItemMappable {
  String toJson() {
    return TodoItemMapper.ensureInitialized().encodeJson<TodoItem>(
      this as TodoItem,
    );
  }

  Map<String, dynamic> toMap() {
    return TodoItemMapper.ensureInitialized().encodeMap<TodoItem>(
      this as TodoItem,
    );
  }

  TodoItemCopyWith<TodoItem, TodoItem, TodoItem> get copyWith =>
      _TodoItemCopyWithImpl<TodoItem, TodoItem>(
        this as TodoItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TodoItemMapper.ensureInitialized().stringifyValue(this as TodoItem);
  }

  @override
  bool operator ==(Object other) {
    return TodoItemMapper.ensureInitialized().equalsValue(
      this as TodoItem,
      other,
    );
  }

  @override
  int get hashCode {
    return TodoItemMapper.ensureInitialized().hashValue(this as TodoItem);
  }
}

extension TodoItemValueCopy<$R, $Out> on ObjectCopyWith<$R, TodoItem, $Out> {
  TodoItemCopyWith<$R, TodoItem, $Out> get $asTodoItem =>
      $base.as((v, t, t2) => _TodoItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TodoItemCopyWith<$R, $In extends TodoItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? text, bool? isDone});
  TodoItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TodoItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TodoItem, $Out>
    implements TodoItemCopyWith<$R, TodoItem, $Out> {
  _TodoItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TodoItem> $mapper =
      TodoItemMapper.ensureInitialized();
  @override
  $R call({String? id, String? text, bool? isDone}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (text != null) #text: text,
      if (isDone != null) #isDone: isDone,
    }),
  );
  @override
  TodoItem $make(CopyWithData data) => TodoItem(
    id: data.get(#id, or: $value.id),
    text: data.get(#text, or: $value.text),
    isDone: data.get(#isDone, or: $value.isDone),
  );

  @override
  TodoItemCopyWith<$R2, TodoItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TodoItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NoteMapper extends ClassMapperBase<Note> {
  NoteMapper._();

  static NoteMapper? _instance;
  static NoteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NoteMapper._());
      NoteTypeMapper.ensureInitialized();
      TodoItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Note';

  static String _$id(Note v) => v.id;
  static const Field<Note, String> _f$id = Field('id', _$id);
  static String _$userId(Note v) => v.userId;
  static const Field<Note, String> _f$userId = Field('userId', _$userId);
  static String _$title(Note v) => v.title;
  static const Field<Note, String> _f$title = Field('title', _$title);
  static String _$content(Note v) => v.content;
  static const Field<Note, String> _f$content = Field('content', _$content);
  static DateTime _$updatedAt(Note v) => v.updatedAt;
  static const Field<Note, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static int _$colorValue(Note v) => v.colorValue;
  static const Field<Note, int> _f$colorValue = Field(
    'colorValue',
    _$colorValue,
    opt: true,
    def: 0xFFFFFFFF,
  );
  static NoteType _$type(Note v) => v.type;
  static const Field<Note, NoteType> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: NoteType.note,
  );
  static List<TodoItem> _$todos(Note v) => v.todos;
  static const Field<Note, List<TodoItem>> _f$todos = Field(
    'todos',
    _$todos,
    opt: true,
    def: const [],
  );
  static SyncStatus _$syncStatus(Note v) => v.syncStatus;
  static const Field<Note, SyncStatus> _f$syncStatus = Field(
    'syncStatus',
    _$syncStatus,
    opt: true,
    def: SyncStatus.pendingCreate,
  );

  @override
  final MappableFields<Note> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #title: _f$title,
    #content: _f$content,
    #updatedAt: _f$updatedAt,
    #colorValue: _f$colorValue,
    #type: _f$type,
    #todos: _f$todos,
    #syncStatus: _f$syncStatus,
  };

  static Note _instantiate(DecodingData data) {
    return Note(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      title: data.dec(_f$title),
      content: data.dec(_f$content),
      updatedAt: data.dec(_f$updatedAt),
      colorValue: data.dec(_f$colorValue),
      type: data.dec(_f$type),
      todos: data.dec(_f$todos),
      syncStatus: data.dec(_f$syncStatus),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Note fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Note>(map);
  }

  static Note fromJson(String json) {
    return ensureInitialized().decodeJson<Note>(json);
  }
}

mixin NoteMappable {
  String toJson() {
    return NoteMapper.ensureInitialized().encodeJson<Note>(this as Note);
  }

  Map<String, dynamic> toMap() {
    return NoteMapper.ensureInitialized().encodeMap<Note>(this as Note);
  }

  NoteCopyWith<Note, Note, Note> get copyWith =>
      _NoteCopyWithImpl<Note, Note>(this as Note, $identity, $identity);
  @override
  String toString() {
    return NoteMapper.ensureInitialized().stringifyValue(this as Note);
  }

  @override
  bool operator ==(Object other) {
    return NoteMapper.ensureInitialized().equalsValue(this as Note, other);
  }

  @override
  int get hashCode {
    return NoteMapper.ensureInitialized().hashValue(this as Note);
  }
}

extension NoteValueCopy<$R, $Out> on ObjectCopyWith<$R, Note, $Out> {
  NoteCopyWith<$R, Note, $Out> get $asNote =>
      $base.as((v, t, t2) => _NoteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NoteCopyWith<$R, $In extends Note, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, TodoItem, TodoItemCopyWith<$R, TodoItem, TodoItem>>
  get todos;
  $R call({
    String? id,
    String? userId,
    String? title,
    String? content,
    DateTime? updatedAt,
    int? colorValue,
    NoteType? type,
    List<TodoItem>? todos,
    SyncStatus? syncStatus,
  });
  NoteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NoteCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Note, $Out>
    implements NoteCopyWith<$R, Note, $Out> {
  _NoteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Note> $mapper = NoteMapper.ensureInitialized();
  @override
  ListCopyWith<$R, TodoItem, TodoItemCopyWith<$R, TodoItem, TodoItem>>
  get todos => ListCopyWith(
    $value.todos,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(todos: v),
  );
  @override
  $R call({
    String? id,
    String? userId,
    String? title,
    String? content,
    DateTime? updatedAt,
    int? colorValue,
    NoteType? type,
    List<TodoItem>? todos,
    SyncStatus? syncStatus,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (title != null) #title: title,
      if (content != null) #content: content,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (colorValue != null) #colorValue: colorValue,
      if (type != null) #type: type,
      if (todos != null) #todos: todos,
      if (syncStatus != null) #syncStatus: syncStatus,
    }),
  );
  @override
  Note $make(CopyWithData data) => Note(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    title: data.get(#title, or: $value.title),
    content: data.get(#content, or: $value.content),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    colorValue: data.get(#colorValue, or: $value.colorValue),
    type: data.get(#type, or: $value.type),
    todos: data.get(#todos, or: $value.todos),
    syncStatus: data.get(#syncStatus, or: $value.syncStatus),
  );

  @override
  NoteCopyWith<$R2, Note, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NoteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

