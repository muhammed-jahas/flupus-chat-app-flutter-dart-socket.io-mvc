import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._();

  static final SharedPref _instance = SharedPref._();
  static SharedPref get instance => _instance;

  // static const String userId = 'userId';
  static const String userName = 'userName';
  // static const String userPhone = 'userPhone';


  late SharedPreferences sharedPref;
  initStorage() async {
    sharedPref = await SharedPreferences.getInstance();
  }
  //Get User Email
  Future<String?> getUserName() async {
    final username = await sharedPref.getString(userName);
    return username;
  }


}
