// Home page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/admin/admin_login.dart';
import 'package:ecommerce/pages/details.dart';
import 'package:ecommerce/pages/wallet.dart';
import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:flutter/material.dart';

import 'bottomnav.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // color on menu icon click
  bool icecream = false, burger = false, salad = false, pizza = false;

  // get uploaded item from storage
  Stream? fooditemStream;
  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem('Pizza');
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  // display all items horizontally
  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          // if there is data
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //get index
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      detail: ds['Detail'],
                                      name: ds['Name'],
                                      price: ds['Price'],
                                      image: ds['Image'],
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(ds['Image'],
                                      height: 150.0,
                                      width: 150.0,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: Text(ds['Name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppWidget.semiTextFieldStyle()),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  child: Text(ds['Detail'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppWidget.LightTextFieldStyle()),
                                ),
                                SizedBox(height: 5.0),
                                Text('₹ ' + ds['Price'],
                                    style: AppWidget.semiTextFieldStyle()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              :
              // if there is not data
              CircularProgressIndicator();
        });
  }

  // display all items vertically
  Widget allItemsVertically() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          // if there is data
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    //get index
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      detail: ds['Detail'],
                                      name: ds['Name'],
                                      price: ds['Price'],
                                      image: ds['Image'],
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          elevation: 5.0,
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(ds['Image'],
                                          height: 120.0,
                                          width: 120.0,
                                          fit: BoxFit.cover),
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(ds['Name'],
                                          style:
                                              AppWidget.semiTextFieldStyle()),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(ds['Detail'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              AppWidget.LightTextFieldStyle()),
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text('₹ ' + ds['Price'],
                                            style: AppWidget
                                                .semiTextFieldStyle())),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              :
              // if there is not data
              CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User name
                  Text('Welcome Foodie!',
                      style: AppWidget.boldTextFieldStyle()),

                  // Cart icon/admin
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminLogin()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.admin_panel_settings_outlined,
                          color: Colors.white),
                    ),
                  )
                ],
              ),

              SizedBox(height: 20.0),
              // todo: (Home) Headings
              Text('Delicious Food', style: AppWidget.HeadlineTextFieldStyle()),
              Text('Discover and Get Great Food',
                  style: AppWidget.LightTextFieldStyle()),
              SizedBox(height: 20.0),

              // todo: (Home) Categories icons
              showItem(),
              SizedBox(height: 30.0),
              showItemsHorizontal(),
              SizedBox(height: 20.0),
              showItemsVerticle(),
            ],
          ),
        ),
      ),
    );
  }

  // Categories icons
  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // pizza
        GestureDetector(
          onTap: () async {
            icecream = false;
            burger = false;
            salad = false;
            pizza = true;
            fooditemStream = await DatabaseMethods().getFoodItem('Pizza');
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: pizza ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'images/pizza.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

        // burger
        GestureDetector(
          onTap: () async {
            icecream = false;
            burger = true;
            salad = false;
            pizza = false;
            fooditemStream = await DatabaseMethods().getFoodItem('Burger');
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: burger ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'images/burger.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

        // salad/pasta
        GestureDetector(
          onTap: () async {
            icecream = false;
            burger = false;
            salad = true;
            pizza = false;
            fooditemStream = await DatabaseMethods().getFoodItem('Salad');
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: salad ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'images/pasta.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

        // ice-cream icon/drinks
        GestureDetector(
          onTap: () async {
            icecream = true;
            burger = false;
            salad = false;
            pizza = false;
            fooditemStream = await DatabaseMethods().getFoodItem('Ice-cream');
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: icecream ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'images/drinks.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showItemsHorizontal() {
    return Container(
      height: 280,
      child: allItems(),
    );
  }

  Widget showItemsVerticle() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: 280,
        child: allItemsVertically(),
      ), // Correct method to call
    );
  }
}
