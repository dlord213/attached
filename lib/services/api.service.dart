import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/constants.config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  late final PocketBase pb;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    pb = PocketBase(ConstantsConfig.baseApiUrl, authStore: store);
  }
}

final apiService = ApiService();
