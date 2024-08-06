import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/service/shared_pref.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String image, name, detail, price;
  const Details(
      {required this.detail,
      required this.name,
      required this.image,
      required this.price,
      super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // Track price
  int totalPrice = 0;

  // Get user ID
  String? id;
  Future<void> getthesharedpref() async {
    id = await SharedPrefeneceHelper().getUserId();
    setState(() {});
  }

  Future<void> ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    totalPrice = int.parse(widget.price);
    ontheload();
  }

  // Item counter
  int itemCounter = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back icon
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:
                  Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            ),
            SizedBox(height: 20),
            // Dish Image
            Image.network(widget.image,
                fit: BoxFit.cover,
                height: 250,
                width: MediaQuery.of(context).size.width),
            SizedBox(height: 20.0),
            headingCartItems(),
            SizedBox(height: 20.0),
            foodDescription(),
            SizedBox(height: 20.0),
            deliveryTime(),
            Spacer(),
            foodPrice(),
          ],
        ),
      ),
    );
  }

  // Headings and number of items
  Widget headingCartItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Heading
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            widget.name,
            style: AppWidget.semiTextFieldStyle(),
          ),
        ),
        // Number of items
        Row(
          children: [
            // Remove item
            GestureDetector(
              onTap: () {
                setState(() {
                  if (itemCounter > 1) {
                    itemCounter--;
                    totalPrice = totalPrice - int.parse(widget.price);
                  }
                });
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(9)),
                child: Icon(Icons.remove, color: Colors.white),
              ),
            ),
            // Number of items
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(itemCounter.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            // Add item
            GestureDetector(
              onTap: () {
                setState(() {
                  itemCounter++;
                  totalPrice = totalPrice + int.parse(widget.price);
                });
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(9)),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget foodDescription() {
    return Container(
      child: Text(
        widget.detail,
        style: AppWidget.LightTextFieldStyle(),
        maxLines: 3,
      ),
    );
  }

  Widget deliveryTime() {
    return Row(
      children: [
        Text('Delivery Time', style: AppWidget.semiTextFieldStyle()),
        Container(
          margin: EdgeInsets.only(left: 30.0),
          child: Row(
            children: [
              Icon(
                Icons.alarm,
                color: Colors.black54,
              ),
              SizedBox(width: 5),
              Text('30 min', style: AppWidget.semiTextFieldStyle()),
            ],
          ),
        ),
      ],
    );
  }

  Widget foodPrice() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Price', style: AppWidget.semiTextFieldStyle()),
              Text('₹ ' + totalPrice.toString(),
                  style: AppWidget.boldTextFieldStyle()),
            ],
          ),
          // Add to cart
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.black),
            child: Row(
              children: [
                // Add cart text
                Text('Add to cart',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16.0)),
                SizedBox(width: 10),
                // Cart icon
                GestureDetector(
                  onTap: () async {
                    if (id != null) {
                      // To add to database
                      Map<String, dynamic> addItemtoCart = {
                        'Name': widget.name,
                        'Quantity': itemCounter.toString(),
                        'Total': totalPrice.toString(),
                        'Image': widget.image
                      };
                      try {
                        await DatabaseMethods()
                            .addItemtoCart(addItemtoCart, id!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Item Added to Cart!',
                                style: TextStyle(fontSize: 20.0)),
                            backgroundColor: Colors.orangeAccent));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to add item to cart: $e',
                                style: TextStyle(fontSize: 20.0)),
                            backgroundColor: Colors.redAccent));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User ID is not available!',
                              style: TextStyle(fontSize: 20.0)),
                          backgroundColor: Colors.redAccent));
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey),
                      child: Icon(Icons.shopping_cart_outlined,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
