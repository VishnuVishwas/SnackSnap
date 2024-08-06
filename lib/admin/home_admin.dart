import 'package:ecommerce/admin/add_food.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            // heading
            Center(
              child:
                  Text('Home Admin', style: AppWidget.HeadlineTextFieldStyle()),
            ),

            SizedBox(height: 50.0),

            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFood()));
              },
              child: Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset('images/food.jpg',
                            height: 100, width: 100, fit: BoxFit.cover),
                      ),
                      SizedBox(width: 30.0),
                      Text('Add Food Items', style: AppWidget.boxBlack()),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
