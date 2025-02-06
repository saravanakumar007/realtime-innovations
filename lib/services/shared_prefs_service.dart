import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences instance;
  Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }
}
