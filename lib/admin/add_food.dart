import 'dart:io';
import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  // drop down items
  final List<String> foodItems = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  String? value;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  // Pick image
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
      }
    });
  }

  // upload image to firebase storage
  Future<void> uploadItem() async {
    if (selectedImage != null &&
        nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      String addId = randomAlphaNumeric(10);

      try {
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("foodImages").child(addId);
        final UploadTask uploadTask =
            firebaseStorageRef.putFile(selectedImage!);
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();

        Map<String, dynamic> addItem = {
          'Image': downloadUrl,
          'Name': nameController.text,
          'Price': priceController.text,
          'Detail': detailController.text,
        };

        await DatabaseMethods().addFoodItem(addItem, value!).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Food Item has been added Successfully",
                  style: TextStyle(fontSize: 18.0)),
              backgroundColor: Colors.orangeAccent));
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to upload item: $e",
                style: TextStyle(fontSize: 18.0)),
            backgroundColor: Colors.redAccent));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please fill in all fields and select an image",
              style: TextStyle(fontSize: 18.0)),
          backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text('Add Item', style: AppWidget.HeadlineTextFieldStyle()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text('Upload the Item Picture',
                  style: AppWidget.semiTextFieldStyle()),
              SizedBox(height: 20.0),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 150.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                Image.file(selectedImage!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 30),
              Text('Item Name', style: AppWidget.semiTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Item Name',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins', color: Colors.black54)),
                ),
              ),
              SizedBox(height: 30),
              Text('Item Price', style: AppWidget.semiTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Item Price',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins', color: Colors.black54)),
                ),
              ),
              SizedBox(height: 30),
              Text('Item Detail', style: AppWidget.semiTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 7,
                  controller: detailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Item Detail',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins', color: Colors.black54)),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Select Category", style: AppWidget.semiTextFieldStyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  items: foodItems
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          )))
                      .toList(),
                  onChanged: ((value) => setState(() {
                        this.value = value;
                      })),
                  dropdownColor: Colors.white,
                  hint: Text("Select Category"),
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  value: value,
                )),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
