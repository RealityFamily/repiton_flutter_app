import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/core/tokenStorage/secure_token_storage.dart';

Future<void> preInit() async {
  GetIt.I.allowReassignment = true;

  final restService = await RepitonApiContainer.init("https://backend.repiton.dev.realityfamily.ru:9046/api/v1/");
  GetIt.I.registerSingleton<RepitonApiContainer>(restService);

  final tokenStorage = await SecureTokenStorage.init();
  GetIt.I.registerSingleton<SecureTokenStorage>(tokenStorage);
}
