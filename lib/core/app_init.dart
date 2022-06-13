import 'package:get_it/get_it.dart';
import 'package:repiton/core/network/repiton_api/repiton_api_container.dart';
import 'package:repiton/core/tokenStorage/secure_token_storage.dart';

Future<void> preInit() async {
  GetIt.I.allowReassignment = true;

  final tokenStorage = await SecureTokenStorage.init();
  GetIt.I.registerSingleton<SecureTokenStorage>(tokenStorage);

  final restService = await RepitonApiContainer.init("https://backend.repiton.dev.realityfamily.ru:9046/api/v1/");
  if (tokenStorage.authToken != null) restService.setToken(tokenStorage.authToken!);
  GetIt.I.registerSingleton<RepitonApiContainer>(restService);
}
