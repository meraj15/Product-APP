import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatefulWidget {
   const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
@override
  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        title:const Text('Address Form'),
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
             const SizedBox(height: 23.0),
              _buildTextField(providerRead.userStreet, 'Address'),
             const SizedBox(height: 23.0),
              _buildTextField(providerRead.userCity, 'City'),
             const SizedBox(height: 23.0),
              _buildTextField(providerRead.userState, 'State/Province/Region'),
             const SizedBox(height: 23.0),
              _buildTextField(providerRead.userZipCode, 'Zip Code (Postal Code)'),
             const SizedBox(height: 23.0),
              _buildTextField(providerRead.userCountry, 'Country'),
             const SizedBox(height: 32.0),
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
                    providerRead.updateAddressData(userID);
                  } else {
                    providerRead.saveAddress(cardProduct);
                  }
                 
                providerRead.addCard.clear();
                  
                          Navigator.of(context).pushNamed(AppRoutes.paymentmethodscreen);

                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:const EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Text(
                  providerRead.isAddressFetched ? "Confirm ADDRESS" : "SAVE ADDRESS",
                  style:const TextStyle(
                    fontSize: 16.0,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
             const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  await providerRead.getCurrentLocation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:const EdgeInsets.symmetric(vertical: 14.0),
                ),
                child:const Text(
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
            offset:const Offset(0, 1),
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
          labelStyle:const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
