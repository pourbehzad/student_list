import 'package:dio/dio.dart';
import 'package:student_list/constants.dart';
import 'package:student_list/models/user.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<User>> getUsers() async {
    try {
      Response response = await dio.get('/student');
      List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Fale To Load User $e');
    }
  }

  Future<User> createUsers(
    String name,
    String number,
    List<String> courses,
  ) async {
    try {
      Response response = await dio.post(
        '/student',
        data: {'name': name, 'number': number, 'courses': courses},
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<User> updateUser(
    String id,
    String name,
    String number,
    List<String> courses,
  ) async {
    try {
      Response response = await dio.put(
        '/student/$id',
        data: {'name': name, 'number': number, 'courses': courses},
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deletUser(String id) async {
    try {
      await dio.delete('/student/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
