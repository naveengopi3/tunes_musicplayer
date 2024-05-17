part of 'mostplayed_bloc.dart';

class MostplayedState {
  List<MostlyPlayedModel>mpStateList;

  MostplayedState({required this.mpStateList});

}

 class MostplayedInitial extends MostplayedState {
  MostplayedInitial():super(mpStateList: []);
  
}
