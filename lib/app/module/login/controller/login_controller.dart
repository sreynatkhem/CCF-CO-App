import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final isLoadingLogin = false.obs;
  Future<void> onLogin() async {
    isLoadingLogin(true);
    String url = dotenv.get('');
    try {
      // await http.post(url)
    } catch (e) {
    } finally {
      isLoadingLogin(false);
    }
  }
}
