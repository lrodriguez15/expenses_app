import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {super.key});

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
                    const SizedBox(
                      height: 10,
                    ),
                    // ignore: sized_box_for_whitespace
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
          //accept key to remove problem with removing list from element and
          // taking the deleted widget property.
          : ListView(
              children: transactions
                  .map(
                    (tx) => TransactionItem(
                      transaction: tx,
                      deleteTx: deleteTx,
                      key: ValueKey(tx.id),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
