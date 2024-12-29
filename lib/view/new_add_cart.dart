// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:product_app/constant/contant.dart';
// import 'package:product_app/main.dart';
// import 'package:product_app/provider/product_provider.dart';
// import 'package:product_app/routes/app_routes.dart';
// import 'package:provider/provider.dart';

// class AddCard extends StatefulWidget {
//   const AddCard({super.key});

//   @override
//   State<AddCard> createState() => _AddCardState();
// }

// class _AddCardState extends State<AddCard> {
//   @override
//   void initState() {
//     super.initState();
//       context.read<ProductData>().getCartsData(userID);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.scaffoldColor,
//       appBar: AppBar(
//         title: Text(
//           "My Bag",
//           style: GoogleFonts.pacifico(
//             color: AppColor.whiteColor,
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         iconTheme: const IconThemeData(color: AppColor.whiteColor),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: Consumer<ProductData>(
//         builder: (context, productData, child) {
//           final cartItems = productData.addCard;
//           if (cartItems.isEmpty) {
//             return Center(
//               child: Lottie.asset(
//                   "assets/lottie_animation/product_not_selected.json"),
//             );
//           }
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView.separated(
//               separatorBuilder: (context, index) => const SizedBox(height: 17),
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final product = cartItems[index];
//                 final isFavorite = productData.favorite.contains(product);

//                 return Container(
//                   height: 130,
//                   decoration: BoxDecoration(
//                     color: AppColor.whiteColor,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(
//                         blurRadius: 10.0,
//                         color: Colors.black12,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Image.network(
//                           // product.images.first,
//                           product.thumbnail,
//                           width: 115,
//                           height: 130,
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text(
//                               product.title,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 15,
//                                 color: Color(0xff222222),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 4.0,
//                             ),
//                             Text(
//                               'Brand: ${product.brand}',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           product.productQuantity--;
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color: Colors.grey.shade300,
//                                           ),
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Icon(
//                                             Icons.remove,
//                                             color: Colors.grey,
//                                             size: 18.0,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 8.0),
//                                       child: Text(
//                                         product.productQuantity.toString(),
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           product.productQuantity++;
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color: Colors.grey.shade300,
//                                           ),
//                                         ),
//                                         child: const Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Icon(
//                                             Icons.add,
//                                             color: Colors.grey,
//                                             size: 18.0,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   "\$${product.price.toString()}",
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500,
//                                     color: Theme.of(context).colorScheme.primary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               product.returnPolicy,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       PopupMenuButton(
//                         color: Colors.white,
//                         itemBuilder: (context) => [
//                           PopupMenuItem(
//                             onTap: () {
//                               productData.favorites(product);
//                             },
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   isFavorite
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 const Text("Favorites"),
//                               ],
//                             ),
//                           ),
//                           PopupMenuItem(
//                             onTap: () {
//                               // productData.deleteAddCard(index);
//                               productData.totalProductCards.value--;
//                               product.productQuantity = 1;
//                               productData.productSize = "";
//                               // context.read<ProductData>().saveData();
//                             },
//                             child: const Row(
//                               children: [
//                                 Icon(Icons.delete),
//                                 SizedBox(width: 8),
//                                 Text("Delete"),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
    
    
//     );
//   }
// }
