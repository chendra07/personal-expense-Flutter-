import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//component
import './transaction_card.dart';

//model
import '../../model/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _deleteTransaction;

  TransactionList(this._transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    // print('build() TRX List');
    return _transactions.isEmpty
        ? LayoutBuilder(
            builder: ((context, constraints) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No transactions added yet!",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              );
            }),
          )
        : ListView(
            children: _transactions
                .map(
                  (tx) => TransactionCard(
                    key: ValueKey(tx.id),
                    transactions: tx,
                    deleteTransaction: _deleteTransaction,
                  ),
                )
                .toList(),
          );
  }
}
