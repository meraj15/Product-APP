import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatelessWidget {
  const AddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        title: Text('Address Form'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: providerRead.userName,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Full name',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 23.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: providerRead.userAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Address',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 23.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: providerRead.userCity,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'City',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 23.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: providerRead.userState,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'State/Province/Region',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 23.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: providerRead.userZipCode, // Corrected here
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Zip Code (Postal Code)',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 23.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: providerRead.userCountry,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Country',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  providerRead.saveData();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ordered Successfully")));
                  Navigator.of(context)
                      .pushNamed(AppRoutes.bottemNavigationBar);

                  providerRead.loadData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appMainColor,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Text(
                  'SAVE ADDRESS',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                onPressed: () async {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appMainColor,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
