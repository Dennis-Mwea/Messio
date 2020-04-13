import 'package:bloc/bloc.dart';
import 'package:messio/blocs/config/Bloc.dart';
import 'package:messio/utils/SharedObjects.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  @override
  ConfigState get initialState => UnConfigState();

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    if (event is ConfigValueChanged) {
      SharedObjects.prefs.setBool(event.key, event.value);
      yield ConfigChangeState(event.key, event.value);
    }
  }
}
