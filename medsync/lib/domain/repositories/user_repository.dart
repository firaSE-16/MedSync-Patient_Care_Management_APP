import 'package:medsync/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> registerPatient(Map<String, dynamic> data);
  Future<UserModel> login(Map<String, dynamic> data);
}