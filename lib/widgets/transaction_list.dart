import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // This gives the height of the device to get 60% of the height.
      // however, this will be done on the main file to deduct the
      // height of the appBar and the status bar (padding).
      // height: MediaQuery.of(context).size.height * 0.6,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (ctx, idx) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\$${transactions[idx].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[idx].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[idx].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteTx(transactions[idx].id),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
