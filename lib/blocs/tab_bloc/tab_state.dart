part of '../tab_bloc/tab_bloc.dart';

@immutable
sealed class TabState {}

final class TabInitial extends TabState {}

final class CurrentTabIndex extends TabState{

  final int currentTabIndex;

  CurrentTabIndex(this.currentTabIndex);
}
