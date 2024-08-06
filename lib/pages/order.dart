import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/database.dart';
import '../service/shared_pref.dart';
import '../widgets/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    ontheload();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        amount2 = total;
      });
    });
  }

  Future<void> getthesharedpref() async {
    id = await SharedPrefeneceHelper().getUserId();
    wallet = await SharedPrefeneceHelper().getUserWallet();
    setState(() {});
  }

  Future<void> ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getItemCart(id!);
    setState(() {});
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        total = 0; // Reset total before calculating
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            total += int.parse(ds["Total"]);
            return Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 10.0, top: 50),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text(ds["Quantity"])),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Name"],
                            style: AppWidget.semiTextFieldStyle(),
                          ),
                          Text(
                            "\₹ " + ds["Total"],
                            style: AppWidget.semiTextFieldStyle(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      "Food Cart",
                      style: AppWidget.HeadlineTextFieldStyle(),
                    )))),
            SizedBox(
              height: 20.0,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: foodCart()),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  Text(
                    "\₹ " + total.toString(),
                    style: AppWidget.semiTextFieldStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                int amount = int.parse(wallet!) - amount2;
                await DatabaseMethods()
                    .UpdateUserWallet(id!, amount.toString());
                await SharedPrefeneceHelper().saveUserWallet(amount.toString());

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order placed successfully!'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
