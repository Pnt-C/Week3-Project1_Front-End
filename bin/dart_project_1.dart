import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() async {
  int? userId = await login();
  if (userId != null) {
    await menu(userId);
  }
}

Future<int?> login() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();

  if (username == null || password == null || username.isEmpty || password.isEmpty) {
    print("Incomplete input");
    return null;
  }

  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    return result['userId'];
  } else {
    print(response.body);
    return null;
  }
}

Future<void> menu(int userId) async {
  while (true) {
    print("\n===== Menu =====");
    print("1. Show my expenses");
    print("2. Exit");
    stdout.write("Select: ");
    String? choice = stdin.readLineSync();

    if (choice == "1") {
      await showExpenses(userId);
    } else if (choice == "2") {
      print("Goodbye");
      break;
    } else {
      print("Invalid choice");
    }
  }
}

Future<void> showExpenses(int userId) async {
  final url = Uri.parse('http://localhost:3000/expenses/$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final expenses = json.decode(response.body) as List;
    int total = 0;
    print("------------- Your expenses ----------");
    for (var exp in expenses) {
      print("${exp['id']}. ${exp['item']} : ${exp['paid']}฿");
      total += exp['paid'] as int;
    }
    print("Total = $total฿");
  } else {
    print("Failed to load expenses");
  }
}