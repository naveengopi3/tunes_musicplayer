import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';

part 'mostplayed_event.dart';
part 'mostplayed_state.dart';

class MostplayedBloc extends Bloc<MostplayedEvent, MostplayedState> {
  MostplayedBloc() : super(MostplayedInitial()) {
    on<MostlyScreenShow>((event, emit) {
     List<MostlyPlayedModel>mostlyAnalist = mostlyplayedSongs.values.toList();
     return emit(MostplayedState(mpStateList: mostlyAnalist));
    });
  }
}
