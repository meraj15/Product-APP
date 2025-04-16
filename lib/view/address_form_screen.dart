import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        title: const Text('Address Form'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 35.0),
          child: Form(
            key: _formKey, // Attach form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: providerRead.userName,
                  labelText: 'Full Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name should contain only letters and spaces';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23.0),
                _buildTextField(
                  controller: providerRead.userStreet,
                  labelText: 'Address',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23.0),
                _buildTextField(
                  controller: providerRead.userCity,
                  labelText: 'City',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your city';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'City should contain only letters and spaces';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23.0),
                _buildTextField(
                  controller: providerRead.userState,
                  labelText: 'State/Province/Region',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your state/province/region';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23.0),
                _buildTextField(
                  controller: providerRead.userZipCode,
                  labelText: 'Zip Code (Postal Code)',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your zip code';
                    }
                    if (!RegExp(r'^\d{5,10}$').hasMatch(value)) {
                      return 'Zip code should be 5-10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23.0),
                _buildTextField(
                  controller: providerRead.userCountry,
                  labelText: 'Country',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your country';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Country should contain only letters and spaces';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> cardProduct = {
                        'userid': userID,
                        'name': providerRead.userName.text,
                        'street': providerRead.userStreet.text,
                        'city': providerRead.userCity.text,
                        'state': providerRead.userState.text,
                        'zipcode': providerRead.userZipCode.text,
                        'country': providerRead.userCountry.text,
                      };

                      if (providerRead.isAddressFetched) {
                         providerRead.updateAddressData(userID);
                      } else {
                         providerRead.saveAddress(cardProduct);
                      }

                      providerRead.addCard.clear();
                      Navigator.of(context).pushNamed(AppRoutes.paymentmethodscreen);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: Text(
                    providerRead.isAddressFetched ? "Confirm ADDRESS" : "SAVE ADDRESS",
                    style: const TextStyle(
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
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text(
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
        validator: validator,
      ),
    );
  }
}