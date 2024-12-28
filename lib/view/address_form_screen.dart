import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatefulWidget {
   AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getAddressData();
  }
  

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
              _buildTextField(providerRead.userName, 'Full name'),
              SizedBox(height: 23.0),
              _buildTextField(providerRead.userStreet, 'Address'),
              SizedBox(height: 23.0),
              _buildTextField(providerRead.userCity, 'City'),
              SizedBox(height: 23.0),
              _buildTextField(providerRead.userState, 'State/Province/Region'),
              SizedBox(height: 23.0),
              _buildTextField(providerRead.userZipCode, 'Zip Code (Postal Code)'),
              SizedBox(height: 23.0),
              _buildTextField(providerRead.userCountry, 'Country'),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                 Map<String, dynamic> cardProduct = {
                    'userid': userID,
                    'name': providerRead.userName.text,
                    'street': providerRead.userStreet.text,
                    'city': providerRead.userCity.text,
                    'state': providerRead.userState.text,
                    'zipcode': providerRead.userZipCode.text.toString(),
                    'country': providerRead.userCountry.text,
                  };

                  if (providerRead.isAddressFetched) {
                    providerRead.updateData(userID);
                  } else {
                    providerRead.saveAddress(cardProduct);
                  }
                 
                providerRead.addCard.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ordered Successfully")));
                  Navigator.of(context)
                      .pushNamed(AppRoutes.orderScreen);
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appMainColor,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Text(
                  providerRead.isAddressFetched ? "Confirm ADDRESS" : "SAVE ADDRESS",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  await providerRead.getCurrentLocation(context);
                   providerRead.saveData();
                 
                  providerRead.loadData();
                },
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

    Widget _buildTextField(TextEditingController controller, String labelText) {
    return Container(
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
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
