// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 int get currentIndex; String? get selectedUserId; String? get selectedChatId;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.selectedUserId, selectedUserId) || other.selectedUserId == selectedUserId)&&(identical(other.selectedChatId, selectedChatId) || other.selectedChatId == selectedChatId));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,selectedUserId,selectedChatId);

@override
String toString() {
  return 'HomeState(currentIndex: $currentIndex, selectedUserId: $selectedUserId, selectedChatId: $selectedChatId)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 int currentIndex, String? selectedUserId, String? selectedChatId
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentIndex = null,Object? selectedUserId = freezed,Object? selectedChatId = freezed,}) {
  return _then(_self.copyWith(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,selectedUserId: freezed == selectedUserId ? _self.selectedUserId : selectedUserId // ignore: cast_nullable_to_non_nullable
as String?,selectedChatId: freezed == selectedChatId ? _self.selectedChatId : selectedChatId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.currentIndex = 0, this.selectedUserId, this.selectedChatId});
  

@override@JsonKey() final  int currentIndex;
@override final  String? selectedUserId;
@override final  String? selectedChatId;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.selectedUserId, selectedUserId) || other.selectedUserId == selectedUserId)&&(identical(other.selectedChatId, selectedChatId) || other.selectedChatId == selectedChatId));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,selectedUserId,selectedChatId);

@override
String toString() {
  return 'HomeState.homeState(currentIndex: $currentIndex, selectedUserId: $selectedUserId, selectedChatId: $selectedChatId)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 int currentIndex, String? selectedUserId, String? selectedChatId
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentIndex = null,Object? selectedUserId = freezed,Object? selectedChatId = freezed,}) {
  return _then(_HomeState(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,selectedUserId: freezed == selectedUserId ? _self.selectedUserId : selectedUserId // ignore: cast_nullable_to_non_nullable
as String?,selectedChatId: freezed == selectedChatId ? _self.selectedChatId : selectedChatId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
