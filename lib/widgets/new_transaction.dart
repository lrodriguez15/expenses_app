import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function addTx;

  NewTransaction(this.addTx, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: titleController,
          ),
          TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController),
          TextButton(
            child: Text('Add Transaction'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.purple)),
            onPressed: (() {
              addTx(
                titleController.text,
                double.parse(amountController.text),
              );
              print(amountController.text);
            }),
          )
        ]),
      ),
    );
  }
}
