import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatelessWidget {
  const AddressForm({super.key});

  Future<void> getCurrentLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint("Location Denied");
      await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      debugPrint("Latitude=${currentPosition.latitude.toString()}");
      debugPrint("Longitude=${currentPosition.longitude.toString()}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[2];

                final providerRead = context.read<ProductData>();

                providerRead.userAddress.text = place.thoroughfare ?? '';
        providerRead.userCity.text = place.locality ?? '';
        providerRead.userState.text = place.administrativeArea ?? '';
        providerRead.userZipCode.text = place.postalCode ?? '';
        providerRead.userCountry.text = place.country ?? '';

                debugPrint("Address: ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}");
      }
    }
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
              _buildTextField(providerRead.userAddress, 'Address'),
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
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  await getCurrentLocation(context);
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
