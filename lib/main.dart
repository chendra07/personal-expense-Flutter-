import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//component
import './components/InputArea/new_transaction.dart';
import './components/ListTrx/transaction_list.dart';
import './components/Chart/chart.dart';
import './components/UI/custom_switch.dart';

//model
import './model/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
          error: Colors.red,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          caption: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Transaction> _userTransaction = [
    Transaction(
      id: "a1",
      title: "AAA1",
      amount: 11,
      date: DateTime.now(),
    ),
    Transaction(
      id: "a2",
      title: "AAA2",
      amount: 12,
      date: DateTime.now(),
    ),
    Transaction(
      id: "a3",
      title: "AAA3",
      amount: 13,
      date: DateTime.now(),
    ),
    Transaction(
      id: "a4",
      title: "AAA4",
      amount: 14,
      date: DateTime.now(),
    ),
    Transaction(
      id: "a5",
      title: "AAA5",
      amount: 15,
      date: DateTime.now(),
    ),
  ];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: '${DateTime.now()}',
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((item) => item.id == id);
    });
  }

  void _switchHandler(bool value) {
    setState(() {
      _showChart = value;
    });
  }

  double _customHeight(AppBar appBar, double heightPct) {
    return (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
        heightPct;
  }

  //headerComponent
  Widget _iosAppBar(String title, Function onTap) {
    return CupertinoNavigationBar(
      middle: Text(title), //title
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: onTap,
          child: const Icon(CupertinoIcons.add),
        ),
      ]), //actions
    );
  }

  Widget _androidAppBar(String title, Function onPressed) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  //body component
  Widget _pageBody(
    bool isLandscape,
    PreferredSizeWidget appBar,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape == true)
              Column(
                children: [
                  CustomSwitch("Show Chart", _showChart, _switchHandler),
                  _showChart
                      ? Container(
                          height: _customHeight(appBar, 0.6),
                          child: Chart(_recentTransactions),
                        )
                      : Container(
                          height: _customHeight(appBar, 0.6),
                          child: TransactionList(
                              _userTransaction, _deleteTransaction),
                        ),
                ],
              ),
            if (isLandscape == false)
              Column(
                children: [
                  Container(
                    height: _customHeight(appBar, 0.3),
                    child: Chart(_recentTransactions),
                  ),
                  Container(
                    height: _customHeight(appBar, 0.7),
                    child:
                        TransactionList(_userTransaction, _deleteTransaction),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('build() MyHomePageState');
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _iosAppBar(
            "Personal Expenses",
            () => _startAddNewTransaction(),
          )
        : _androidAppBar(
            "Personal Expenses",
            () => _startAddNewTransaction(),
          );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pageBody(_isLandscape, appBar),
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: _pageBody(_isLandscape, appBar),
            floatingActionButtonLocation: Platform.isIOS
                ? Container()
                : FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(),
            ),
          );
  }
}
