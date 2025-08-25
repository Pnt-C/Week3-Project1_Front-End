import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() async {
  Map<String, dynamic>? loginResult = await login();
  if (loginResult != null) {
    await menu(loginResult['userId'], loginResult['username']);
  }
}

Future<Map<String, dynamic>?> login() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();

  if (username == null ||
      password == null ||
      username.isEmpty ||
      password.isEmpty) {
    print("Incomplete input");
    return null;
  }

  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    // Return both userId and username
    return {'userId': result['userId'], 'username': username};
  } else {
    print(response.body);
    return null;
  }
}

Future<void> menu(int userId, String username) async {
  while (true) {
    print("\n========== Expense Tracking App ==========");
    print('Welcome $username');
    print("1. All expenses");
    print("2. Today's expense");
    print("3. Search expense");
    print("4. Add new expense");
    print("5. Delete an expense");
    print("6. Exit");

    stdout.write('Choose...');
    String? choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        print("------------- All expenses -------------");
        // Add code here

        Future<void> allExpenses(int userId) async {
          final url = Uri.parse('http://localhost:3000/expenses/$userId');
          try {
            final response = await http.get(url);

            if (response.statusCode == 200) {
              List<dynamic> expenses = json.decode(response.body);
              if (expenses.isEmpty) {
                print("No expenses found.");
              } else {
                double total = 0;
                for (var exp in expenses) {
                  DateTime date = DateTime.parse(exp['date']);
                  String formattedDate = date
                      .toUtc()
                      .toIso8601String()
                      .replaceAll('T', ' ')
                      .substring(0, 23);
                  print("${exp['id']}. ${exp['item']} : ${exp['paid']}฿ : $formattedDate",);
                  total += double.parse(exp['paid'].toString());
                  }
                print("Total expenses = ${total.toStringAsFixed(0)}฿");
              }
            } else {
              print("Failed to fetch expenses: ${response.body}");
            }
          } catch (error) {
            print("Error connecting to server: $error");
          }
        }
        await allExpenses(userId);

        break;
      case '2':
        print("------------- Today's expense -------------");
        // Add code here
        break;
      case '3':
        print("------------- Search expense -------------");
        // Add code here
        break;
      case '4':
        print("------------- Add new expense -------------");
        // Add code here
        break;
      case '5':
        print("------------- Delete an expense -------------");
        // Add code here
        break;
      case '6':
        print("------ Bye ------");
        return;
      default:
        print("Choose only 1 - 6!!!");
    }
  }
}
