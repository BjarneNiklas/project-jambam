// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'research_agent_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SourceConfig _$SourceConfigFromJson(Map<String, dynamic> json) {
  return _SourceConfig.fromJson(json);
}

/// @nodoc
mixin _$SourceConfig {
  String get name => throw _privateConstructorUsedError;
  SourceCategory get category => throw _privateConstructorUsedError;
  List<EthicalConcern> get ethicalConcerns =>
      throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this SourceConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourceConfigCopyWith<SourceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceConfigCopyWith<$Res> {
  factory $SourceConfigCopyWith(
    SourceConfig value,
    $Res Function(SourceConfig) then,
  ) = _$SourceConfigCopyWithImpl<$Res, SourceConfig>;
  @useResult
  $Res call({
    String name,
    SourceCategory category,
    List<EthicalConcern> ethicalConcerns,
    bool isEnabled,
    int priority,
    String description,
  });
}

/// @nodoc
class _$SourceConfigCopyWithImpl<$Res, $Val extends SourceConfig>
    implements $SourceConfigCopyWith<$Res> {
  _$SourceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? ethicalConcerns = null,
    Object? isEnabled = null,
    Object? priority = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as SourceCategory,
            ethicalConcerns: null == ethicalConcerns
                ? _value.ethicalConcerns
                : ethicalConcerns // ignore: cast_nullable_to_non_nullable
                      as List<EthicalConcern>,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SourceConfigImplCopyWith<$Res>
    implements $SourceConfigCopyWith<$Res> {
  factory _$$SourceConfigImplCopyWith(
    _$SourceConfigImpl value,
    $Res Function(_$SourceConfigImpl) then,
  ) = __$$SourceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    SourceCategory category,
    List<EthicalConcern> ethicalConcerns,
    bool isEnabled,
    int priority,
    String description,
  });
}

/// @nodoc
class __$$SourceConfigImplCopyWithImpl<$Res>
    extends _$SourceConfigCopyWithImpl<$Res, _$SourceConfigImpl>
    implements _$$SourceConfigImplCopyWith<$Res> {
  __$$SourceConfigImplCopyWithImpl(
    _$SourceConfigImpl _value,
    $Res Function(_$SourceConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SourceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? ethicalConcerns = null,
    Object? isEnabled = null,
    Object? priority = null,
    Object? description = null,
  }) {
    return _then(
      _$SourceConfigImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as SourceCategory,
        ethicalConcerns: null == ethicalConcerns
            ? _value._ethicalConcerns
            : ethicalConcerns // ignore: cast_nullable_to_non_nullable
                  as List<EthicalConcern>,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SourceConfigImpl with DiagnosticableTreeMixin implements _SourceConfig {
  const _$SourceConfigImpl({
    required this.name,
    required this.category,
    required final List<EthicalConcern> ethicalConcerns,
    required this.isEnabled,
    required this.priority,
    required this.description,
  }) : _ethicalConcerns = ethicalConcerns;

  factory _$SourceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceConfigImplFromJson(json);

  @override
  final String name;
  @override
  final SourceCategory category;
  final List<EthicalConcern> _ethicalConcerns;
  @override
  List<EthicalConcern> get ethicalConcerns {
    if (_ethicalConcerns is EqualUnmodifiableListView) return _ethicalConcerns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ethicalConcerns);
  }

  @override
  final bool isEnabled;
  @override
  final int priority;
  @override
  final String description;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SourceConfig(name: $name, category: $category, ethicalConcerns: $ethicalConcerns, isEnabled: $isEnabled, priority: $priority, description: $description)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SourceConfig'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('ethicalConcerns', ethicalConcerns))
      ..add(DiagnosticsProperty('isEnabled', isEnabled))
      ..add(DiagnosticsProperty('priority', priority))
      ..add(DiagnosticsProperty('description', description));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceConfigImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._ethicalConcerns,
              _ethicalConcerns,
            ) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    category,
    const DeepCollectionEquality().hash(_ethicalConcerns),
    isEnabled,
    priority,
    description,
  );

  /// Create a copy of SourceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceConfigImplCopyWith<_$SourceConfigImpl> get copyWith =>
      __$$SourceConfigImplCopyWithImpl<_$SourceConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceConfigImplToJson(this);
  }
}

abstract class _SourceConfig implements SourceConfig {
  const factory _SourceConfig({
    required final String name,
    required final SourceCategory category,
    required final List<EthicalConcern> ethicalConcerns,
    required final bool isEnabled,
    required final int priority,
    required final String description,
  }) = _$SourceConfigImpl;

  factory _SourceConfig.fromJson(Map<String, dynamic> json) =
      _$SourceConfigImpl.fromJson;

  @override
  String get name;
  @override
  SourceCategory get category;
  @override
  List<EthicalConcern> get ethicalConcerns;
  @override
  bool get isEnabled;
  @override
  int get priority;
  @override
  String get description;

  /// Create a copy of SourceConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourceConfigImplCopyWith<_$SourceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
