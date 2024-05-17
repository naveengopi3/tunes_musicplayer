part of '../tab_bloc/tab_bloc.dart';

@immutable
sealed class TabEvent {}

class TabChanged extends TabEvent{
  final int newindex;

  TabChanged( this.newindex);
}