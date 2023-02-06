import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // Ensure that we only support portrait mode!
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoApp(
            title: 'Personal Expenses',
            theme: CupertinoThemeData(
              // Primary swatch creates more colors than primary
              primaryColor: Colors.purple,
              primaryContrastingColor: Colors.white,
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            title: 'Personal Expenses',
            theme: ThemeData(
              // Primary swatch creates more colors than primary
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
              errorColor: Colors.red.shade700,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: const TextStyle(
                      color: Colors.purple,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    button: const TextStyle(color: Colors.white),
                  ),
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            home: const MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late String titleInput;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't1',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (element) {
        return element.date.isAfter(
          DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            // This is added to prevent tapping in the modal sheet
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere(((element) => element.id == id));
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          // Automatically adjust the look for iOS
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _showChart,
            onChanged: (bool value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
      _showChart
          // ignore: sized_box_for_whitespace
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Chart(_recentTransactions),
              ),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      // ignore: sized_box_for_whitespace
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Chart(_recentTransactions),
        ),
      ),
      txListWidget,
    ];
  }

  Widget _cupertinoNavigationBar(Widget appTitle) {
    return CupertinoNavigationBar(
      middle: appTitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _materialAppBar(Widget appTitle) {
    return AppBar(
      title: appTitle,
      actions: [
        IconButton(
          onPressed: (() => _startAddNewTransaction(context)),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    const appTitle = Text('Personal Expenses');
    final Widget appBar = Platform.isIOS
        ? _cupertinoNavigationBar(appTitle)
        : _materialAppBar(appTitle);

    // ignore: sized_box_for_whitespace
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              (appBar as PreferredSizeWidget).preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(
                  mediaQuery, appBar as AppBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(
                  mediaQuery, appBar as AppBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: (() => _startAddNewTransaction(context)),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
