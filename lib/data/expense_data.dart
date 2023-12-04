import 'package:flutter/material.dart';
import 'package:project_expenses/data/hive_database.dart';
import 'package:project_expenses/datetime/date_time_helper.dart';
import 'package:project_expenses/models/expense_item.dart';

class ExpenseData extends ChangeNotifier{
  // list of all expenses
  List<ExpenseItem> overallExpenseList=[];

  //get expense list
  List<ExpenseItem> getAllExpenseList(){
    return overallExpenseList;
  }

  final db= HiveDatabase();
  //prepare data to display
  void prepareData(){
    //if there exists a user data pls display it
    if(db.readData().isNotEmpty){
      overallExpenseList=db.readData();
    }
  }


  //add new expense
  void addExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete a expense
  void deleteExpenseItem(ExpenseItem expense) {
    overallExpenseList.removeWhere((item) =>
    item.name == expense.name &&
        item.amount == expense.amount &&
        item.dateTime == expense.dateTime
    );

    notifyListeners();

    db.saveData(overallExpenseList); // Save the updated list without the deleted expense
  }


  //get weekday (mon, tues, etc) from a datetime object
  String getDayName(DateTime dateTime){
    switch(dateTime.weekday){
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  //get the date for the start of the week(sunday)
  DateTime startOfWeekDate(){
    DateTime? startOfWeek;

    //get todays date
    DateTime today= DateTime.now();

    for(int i=0;i<7;i++){
      if(getDayName(today.subtract(Duration(days: i)))=='Sun'){
        startOfWeek= today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }


  /*
  convert overall list of expenses into a daily expense summary

  [
  expenses of all the days
  ]

  [
  daily expense summary
  ]

   */
    Map<String,double> calculateDailyExpenseSummary(){
      Map<String,double> dailyExpenseSummary={
        //date (yyymmdd):amountTotalfor that day
      };
      for(var expense in overallExpenseList){
        String date= convertDateTimeTostring(expense.dateTime);
        double amount=double.parse(expense.amount);

        if(dailyExpenseSummary.containsKey(date)){
          double currentAmount= dailyExpenseSummary[date]!;
          currentAmount+=amount;
          dailyExpenseSummary[date]=currentAmount;
        }else{
          dailyExpenseSummary.addAll({date: amount});
        }
      }
      return dailyExpenseSummary;
    }
}