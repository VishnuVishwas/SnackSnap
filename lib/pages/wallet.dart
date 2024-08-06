import 'package:ecommerce/widgets/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_india.dart';

import '../service/database.dart';
import '../service/shared_pref.dart';
import '../widgets/upi_payment.dart';
import '../widgets/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  // amount selected
  bool hundred = false,
      twohundred = false,
      fivehundred = false,
      thousand = true;

  // amount
  int amount = 1000;
  int walletamount = 0;

  final UpiPaymentService _upiPaymentService = UpiPaymentService();
  List<UpiApp>? _apps;

  // to update user wallet in firebase
  String? wallet;
  String? id;

  Future<void> getSharedPref() async {
    wallet = await SharedPrefeneceHelper().getUserWallet();
    id = await SharedPrefeneceHelper().getUserId();
    setState(() {
      walletamount = int.tryParse(wallet ?? '0') ?? 0;
    });
  }

  void onLoad() async {
    await getSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onLoad();
    _loadUpiApps();
  }

  // Load the UPI apps.
  void _loadUpiApps() async {
    _apps = await _upiPaymentService.getAllUpiApps();
    setState(() {});
  }

  // Initiates a transaction using the selected UPI app.
  void _initiateTransaction(UpiApp app, int amount) async {
    // Print to debug
    print('Initiating transaction for amount: $amount');
    int transactionAmount =
        await _upiPaymentService.initiateTransaction(app, amount);
    walletamount += transactionAmount;
    setState(() {});

    await SharedPrefeneceHelper().saveUserWallet(walletamount.toString());
    await DatabaseMethods().UpdateUserWallet(id!, walletamount.toString());

    // Show Snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('₹$transactionAmount added to your wallet!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet - Heading
            Material(
              elevation: 2.0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text('Wallet',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            Container(
              child: Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        // Wallet icon
                        Container(
                          child: Image.asset('images/wallet.png',
                              height: 60, width: 60, fit: BoxFit.cover),
                        ),
                        SizedBox(width: 40.0),

                        // Wallet info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Wallet',
                                style: AppWidget.LightTextFieldStyle()),
                            Row(
                              children: [
                                Icon(Icons.currency_rupee, size: 20),
                                Text('$walletamount',
                                    style: AppWidget.semiTextFieldStyle()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Add money
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Add money", style: AppWidget.semiTextFieldStyle()),
            ),

            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // $100
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hundred = true;
                      twohundred = false;
                      fivehundred = false;
                      thousand = false;
                      amount = 100;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5),
                        color: hundred ? Colors.black54 : Colors.white),
                    child: Row(
                      children: [
                        Icon(Icons.currency_rupee,
                            size: 20,
                            color: hundred ? Colors.white : Colors.black),
                        Text('100',
                            style: hundred
                                ? AppWidget.boxBlack()
                                : AppWidget.semiTextFieldStyle()),
                      ],
                    ),
                  ),
                ),

                // $200
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hundred = false;
                      twohundred = true;
                      fivehundred = false;
                      thousand = false;
                      amount = 200;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5),
                        color: twohundred ? Colors.black54 : Colors.white),
                    child: Row(
                      children: [
                        Icon(Icons.currency_rupee,
                            size: 20,
                            color: twohundred ? Colors.white : Colors.black),
                        Text('200',
                            style: twohundred
                                ? AppWidget.boxBlack()
                                : AppWidget.semiTextFieldStyle()),
                      ],
                    ),
                  ),
                ),

                // $500
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hundred = false;
                      twohundred = false;
                      fivehundred = true;
                      thousand = false;
                      amount = 500;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5),
                        color: fivehundred ? Colors.black54 : Colors.white),
                    child: Row(
                      children: [
                        Icon(Icons.currency_rupee,
                            size: 20,
                            color: fivehundred ? Colors.white : Colors.black),
                        Text('500',
                            style: fivehundred
                                ? AppWidget.boxBlack()
                                : AppWidget.semiTextFieldStyle()),
                      ],
                    ),
                  ),
                ),

                // $1000
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hundred = false;
                      twohundred = false;
                      fivehundred = false;
                      thousand = true;
                      amount = 1000;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5),
                        color: thousand ? Colors.black54 : Colors.white),
                    child: Row(
                      children: [
                        Icon(Icons.currency_rupee,
                            size: 20,
                            color: thousand ? Colors.white : Colors.black),
                        Text('1000',
                            style: thousand
                                ? AppWidget.boxBlack()
                                : AppWidget.semiTextFieldStyle()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.0),

            // Payment icon
            paymentIcon(),
          ],
        ),
      ),
    );
  }

  Widget paymentIcon() {
    return GestureDetector(
      onTap: () {
        print('Amount to be paid: $amount'); // Debug amount
        if (_apps != null && _apps!.isNotEmpty) {
          _initiateTransaction(_apps!.first, amount);
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add with ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            Image.asset('images/googleIcon.png',
                height: 25.0, width: 25.0, fit: BoxFit.fill),
            Text(' Pay',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
