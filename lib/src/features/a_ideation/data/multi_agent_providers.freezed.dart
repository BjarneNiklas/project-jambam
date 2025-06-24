// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_agent_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIInsight _$AIInsightFromJson(Map<String, dynamic> json) {
  return _AIInsight.fromJson(json);
}

/// @nodoc
mixin _$AIInsight {
  String get id => throw _privateConstructorUsedError;
  AIInsightType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  InsightPriority get priority => throw _privateConstructorUsedError;
  List<String> get suggestedActions => throw _privateConstructorUsedError;
  bool get resolved => throw _privateConstructorUsedError;

  /// Serializes this AIInsight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIInsightCopyWith<AIInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIInsightCopyWith<$Res> {
  factory $AIInsightCopyWith(AIInsight value, $Res Function(AIInsight) then) =
      _$AIInsightCopyWithImpl<$Res, AIInsight>;
  @useResult
  $Res call({
    String id,
    AIInsightType type,
    String title,
    String description,
    InsightPriority priority,
    List<String> suggestedActions,
    bool resolved,
  });
}

/// @nodoc
class _$AIInsightCopyWithImpl<$Res, $Val extends AIInsight>
    implements $AIInsightCopyWith<$Res> {
  _$AIInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? suggestedActions = null,
    Object? resolved = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AIInsightType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as InsightPriority,
            suggestedActions: null == suggestedActions
                ? _value.suggestedActions
                : suggestedActions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            resolved: null == resolved
                ? _value.resolved
                : resolved // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIInsightImplCopyWith<$Res>
    implements $AIInsightCopyWith<$Res> {
  factory _$$AIInsightImplCopyWith(
    _$AIInsightImpl value,
    $Res Function(_$AIInsightImpl) then,
  ) = __$$AIInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    AIInsightType type,
    String title,
    String description,
    InsightPriority priority,
    List<String> suggestedActions,
    bool resolved,
  });
}

/// @nodoc
class __$$AIInsightImplCopyWithImpl<$Res>
    extends _$AIInsightCopyWithImpl<$Res, _$AIInsightImpl>
    implements _$$AIInsightImplCopyWith<$Res> {
  __$$AIInsightImplCopyWithImpl(
    _$AIInsightImpl _value,
    $Res Function(_$AIInsightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? suggestedActions = null,
    Object? resolved = null,
  }) {
    return _then(
      _$AIInsightImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AIInsightType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as InsightPriority,
        suggestedActions: null == suggestedActions
            ? _value._suggestedActions
            : suggestedActions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        resolved: null == resolved
            ? _value.resolved
            : resolved // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIInsightImpl implements _AIInsight {
  const _$AIInsightImpl({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    required final List<String> suggestedActions,
    this.resolved = false,
  }) : _suggestedActions = suggestedActions;

  factory _$AIInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIInsightImplFromJson(json);

  @override
  final String id;
  @override
  final AIInsightType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final InsightPriority priority;
  final List<String> _suggestedActions;
  @override
  List<String> get suggestedActions {
    if (_suggestedActions is EqualUnmodifiableListView)
      return _suggestedActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedActions);
  }

  @override
  @JsonKey()
  final bool resolved;

  @override
  String toString() {
    return 'AIInsight(id: $id, type: $type, title: $title, description: $description, priority: $priority, suggestedActions: $suggestedActions, resolved: $resolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(
              other._suggestedActions,
              _suggestedActions,
            ) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    title,
    description,
    priority,
    const DeepCollectionEquality().hash(_suggestedActions),
    resolved,
  );

  /// Create a copy of AIInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIInsightImplCopyWith<_$AIInsightImpl> get copyWith =>
      __$$AIInsightImplCopyWithImpl<_$AIInsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIInsightImplToJson(this);
  }
}

abstract class _AIInsight implements AIInsight {
  const factory _AIInsight({
    required final String id,
    required final AIInsightType type,
    required final String title,
    required final String description,
    required final InsightPriority priority,
    required final List<String> suggestedActions,
    final bool resolved,
  }) = _$AIInsightImpl;

  factory _AIInsight.fromJson(Map<String, dynamic> json) =
      _$AIInsightImpl.fromJson;

  @override
  String get id;
  @override
  AIInsightType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  InsightPriority get priority;
  @override
  List<String> get suggestedActions;
  @override
  bool get resolved;

  /// Create a copy of AIInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIInsightImplCopyWith<_$AIInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RetrospectiveSession _$RetrospectiveSessionFromJson(Map<String, dynamic> json) {
  return _RetrospectiveSession.fromJson(json);
}

/// @nodoc
mixin _$RetrospectiveSession {
  String get id => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  List<ActionItem> get actionItems => throw _privateConstructorUsedError;

  /// Serializes this RetrospectiveSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RetrospectiveSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RetrospectiveSessionCopyWith<RetrospectiveSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetrospectiveSessionCopyWith<$Res> {
  factory $RetrospectiveSessionCopyWith(
    RetrospectiveSession value,
    $Res Function(RetrospectiveSession) then,
  ) = _$RetrospectiveSessionCopyWithImpl<$Res, RetrospectiveSession>;
  @useResult
  $Res call({
    String id,
    String projectId,
    DateTime date,
    List<String> insights,
    List<String> recommendations,
    List<ActionItem> actionItems,
  });
}

/// @nodoc
class _$RetrospectiveSessionCopyWithImpl<
  $Res,
  $Val extends RetrospectiveSession
>
    implements $RetrospectiveSessionCopyWith<$Res> {
  _$RetrospectiveSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RetrospectiveSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? date = null,
    Object? insights = null,
    Object? recommendations = null,
    Object? actionItems = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            insights: null == insights
                ? _value.insights
                : insights // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            actionItems: null == actionItems
                ? _value.actionItems
                : actionItems // ignore: cast_nullable_to_non_nullable
                      as List<ActionItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RetrospectiveSessionImplCopyWith<$Res>
    implements $RetrospectiveSessionCopyWith<$Res> {
  factory _$$RetrospectiveSessionImplCopyWith(
    _$RetrospectiveSessionImpl value,
    $Res Function(_$RetrospectiveSessionImpl) then,
  ) = __$$RetrospectiveSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String projectId,
    DateTime date,
    List<String> insights,
    List<String> recommendations,
    List<ActionItem> actionItems,
  });
}

/// @nodoc
class __$$RetrospectiveSessionImplCopyWithImpl<$Res>
    extends _$RetrospectiveSessionCopyWithImpl<$Res, _$RetrospectiveSessionImpl>
    implements _$$RetrospectiveSessionImplCopyWith<$Res> {
  __$$RetrospectiveSessionImplCopyWithImpl(
    _$RetrospectiveSessionImpl _value,
    $Res Function(_$RetrospectiveSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RetrospectiveSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? date = null,
    Object? insights = null,
    Object? recommendations = null,
    Object? actionItems = null,
  }) {
    return _then(
      _$RetrospectiveSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        insights: null == insights
            ? _value._insights
            : insights // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        actionItems: null == actionItems
            ? _value._actionItems
            : actionItems // ignore: cast_nullable_to_non_nullable
                  as List<ActionItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RetrospectiveSessionImpl implements _RetrospectiveSession {
  const _$RetrospectiveSessionImpl({
    required this.id,
    required this.projectId,
    required this.date,
    required final List<String> insights,
    required final List<String> recommendations,
    required final List<ActionItem> actionItems,
  }) : _insights = insights,
       _recommendations = recommendations,
       _actionItems = actionItems;

  factory _$RetrospectiveSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RetrospectiveSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String projectId;
  @override
  final DateTime date;
  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  final List<ActionItem> _actionItems;
  @override
  List<ActionItem> get actionItems {
    if (_actionItems is EqualUnmodifiableListView) return _actionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionItems);
  }

  @override
  String toString() {
    return 'RetrospectiveSession(id: $id, projectId: $projectId, date: $date, insights: $insights, recommendations: $recommendations, actionItems: $actionItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetrospectiveSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            const DeepCollectionEquality().equals(
              other._actionItems,
              _actionItems,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    projectId,
    date,
    const DeepCollectionEquality().hash(_insights),
    const DeepCollectionEquality().hash(_recommendations),
    const DeepCollectionEquality().hash(_actionItems),
  );

  /// Create a copy of RetrospectiveSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetrospectiveSessionImplCopyWith<_$RetrospectiveSessionImpl>
  get copyWith =>
      __$$RetrospectiveSessionImplCopyWithImpl<_$RetrospectiveSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RetrospectiveSessionImplToJson(this);
  }
}

abstract class _RetrospectiveSession implements RetrospectiveSession {
  const factory _RetrospectiveSession({
    required final String id,
    required final String projectId,
    required final DateTime date,
    required final List<String> insights,
    required final List<String> recommendations,
    required final List<ActionItem> actionItems,
  }) = _$RetrospectiveSessionImpl;

  factory _RetrospectiveSession.fromJson(Map<String, dynamic> json) =
      _$RetrospectiveSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get projectId;
  @override
  DateTime get date;
  @override
  List<String> get insights;
  @override
  List<String> get recommendations;
  @override
  List<ActionItem> get actionItems;

  /// Create a copy of RetrospectiveSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetrospectiveSessionImplCopyWith<_$RetrospectiveSessionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ActionItem _$ActionItemFromJson(Map<String, dynamic> json) {
  return _ActionItem.fromJson(json);
}

/// @nodoc
mixin _$ActionItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get assignee => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  ActionPriority get priority => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this ActionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionItemCopyWith<ActionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionItemCopyWith<$Res> {
  factory $ActionItemCopyWith(
    ActionItem value,
    $Res Function(ActionItem) then,
  ) = _$ActionItemCopyWithImpl<$Res, ActionItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String assignee,
    DateTime dueDate,
    ActionPriority priority,
    bool completed,
  });
}

/// @nodoc
class _$ActionItemCopyWithImpl<$Res, $Val extends ActionItem>
    implements $ActionItemCopyWith<$Res> {
  _$ActionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? assignee = null,
    Object? dueDate = null,
    Object? priority = null,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            assignee: null == assignee
                ? _value.assignee
                : assignee // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as ActionPriority,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActionItemImplCopyWith<$Res>
    implements $ActionItemCopyWith<$Res> {
  factory _$$ActionItemImplCopyWith(
    _$ActionItemImpl value,
    $Res Function(_$ActionItemImpl) then,
  ) = __$$ActionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String assignee,
    DateTime dueDate,
    ActionPriority priority,
    bool completed,
  });
}

/// @nodoc
class __$$ActionItemImplCopyWithImpl<$Res>
    extends _$ActionItemCopyWithImpl<$Res, _$ActionItemImpl>
    implements _$$ActionItemImplCopyWith<$Res> {
  __$$ActionItemImplCopyWithImpl(
    _$ActionItemImpl _value,
    $Res Function(_$ActionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? assignee = null,
    Object? dueDate = null,
    Object? priority = null,
    Object? completed = null,
  }) {
    return _then(
      _$ActionItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        assignee: null == assignee
            ? _value.assignee
            : assignee // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as ActionPriority,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionItemImpl implements _ActionItem {
  const _$ActionItemImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.dueDate,
    required this.priority,
    this.completed = false,
  });

  factory _$ActionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String assignee;
  @override
  final DateTime dueDate;
  @override
  final ActionPriority priority;
  @override
  @JsonKey()
  final bool completed;

  @override
  String toString() {
    return 'ActionItem(id: $id, title: $title, description: $description, assignee: $assignee, dueDate: $dueDate, priority: $priority, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.assignee, assignee) ||
                other.assignee == assignee) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    assignee,
    dueDate,
    priority,
    completed,
  );

  /// Create a copy of ActionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionItemImplCopyWith<_$ActionItemImpl> get copyWith =>
      __$$ActionItemImplCopyWithImpl<_$ActionItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionItemImplToJson(this);
  }
}

abstract class _ActionItem implements ActionItem {
  const factory _ActionItem({
    required final String id,
    required final String title,
    required final String description,
    required final String assignee,
    required final DateTime dueDate,
    required final ActionPriority priority,
    final bool completed,
  }) = _$ActionItemImpl;

  factory _ActionItem.fromJson(Map<String, dynamic> json) =
      _$ActionItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get assignee;
  @override
  DateTime get dueDate;
  @override
  ActionPriority get priority;
  @override
  bool get completed;

  /// Create a copy of ActionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionItemImplCopyWith<_$ActionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
