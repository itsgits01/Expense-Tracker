import 'package:flutter/material.dart';
import 'package:project_expenses/compoenets/expense_summary.dart';
import 'package:project_expenses/compoenets/expense_tile.dart';
import 'package:project_expenses/compoenets/neu_box.dart';
import 'package:project_expenses/data/expense_data.dart';
import 'package:project_expenses/models/expense_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {


  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prepare the data
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }


//add a new expense
  void addNewExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: InputDecoration(hintText: 'Expense Name'),
            ),
            //expense amount
            TextField(
              controller: newExpenseAmountController,
              decoration: InputDecoration(hintText: 'Expense Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          //save button
          ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              save(context);
            },
            child: Text('Save'),
          ),
          SizedBox(
            width: 10,
          ),
          //cancle button
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              cancel(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context, listen: false).deleteExpenseItem(expense);
  }

//save method
  void save(BuildContext context) {
    if(newExpenseAmountController.text.isNotEmpty && newExpenseNameController.text.isNotEmpty){
      //cerate a expense item
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text.toString(),
          amount: newExpenseAmountController.text.toString(),
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false).addExpense(newExpense);
    }
    Navigator.pop(context);
    clear();
  }

//cancle method
  void cancel(BuildContext context) {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => addNewExpense(context),
          child: Icon(Icons.add),
          shape: StadiumBorder(),
        ),

        body: ListView(
          children: [
            //weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

            const SizedBox(height: 30,),
            //expenses
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ExpenseTile(
                          name: value.getAllExpenseList()[index].name,
                          amount: value.getAllExpenseList()[index].amount,
                          dateTime: value.getAllExpenseList()[index].dateTime,
                        deleteTapped: (p0)=>deleteExpense(value.getAllExpenseList()[index]),
                      ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
