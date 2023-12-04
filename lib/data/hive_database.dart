import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_expenses/models/expense_item.dart';

class HiveDatabase {
  //reference outbox
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List<ExpenseItem> allExpenses) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expenses in allExpenses) {
      List<dynamic> expensesFormatted = [
        expenses.name,
        expenses.amount,
        expenses.dateTime,
      ];
      allExpensesFormatted.add(expensesFormatted);
    }

    //finally store in ourdatabase
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
  List<ExpenseItem> readData() {
    List saveExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < saveExpenses.length; i++) {
      //collect individual expense data
      String name = saveExpenses[i][0];
      String amount = saveExpenses[i][1];
      DateTime dateTime = saveExpenses[i][2];

      //finally create a expense item
      ExpenseItem expense =
          ExpenseItem(name: name, amount: amount, dateTime: dateTime);

      //add expenses to overall list of expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }

  void deleteExpense(ExpenseItem expense) {
    List<List<dynamic>> savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];

    savedExpenses.removeWhere((savedExpense) =>
    savedExpense[0] == expense.name &&
        savedExpense[1] == expense.amount &&
        savedExpense[2] == expense.dateTime.millisecondsSinceEpoch);

    _myBox.put("ALL_EXPENSES", savedExpenses);
  }


}
