import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:flutter/material.dart';

import '../widgets/content_model.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int cureentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  cureentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 40.0),
                  child: Column(
                    children: [
                      // image
                      Image.asset(
                        contents[i].image,
                        height: 450,
                        width: MediaQuery.of(context).size.width / 1,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 40.0),
                      // title
                      Text(contents[i].title,
                          style: AppWidget.HeadlineTextFieldStyle()),
                      SizedBox(height: 20.0),
                      // description
                      Text(contents[i].description,
                          style: AppWidget.LightTextFieldStyle())
                    ],
                  ),
                );
              }),
        ),

        // dots - number of pages
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                contents.length, (index) => buildDot(index, context)),
          ),
        ),

        // next page button
        GestureDetector(
          onTap: () {
            if (cureentIndex == contents.length - 1) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            }
            _controller.nextPage(
                duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: Center(
                child: Text(
                    cureentIndex == contents.length - 1 ? "Start" : 'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold))),
          ),
        )
      ],
    ));
  }

  // dots - number of pages
  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: cureentIndex == index ? 18 : 7,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black38),
    );
  }
}
