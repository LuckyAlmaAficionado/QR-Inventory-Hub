import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final AuthController authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = 'Add Product';
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.ADD_PRODUCT);
              break;
            case 1:
              title = 'Product';
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.PRODUCTS);
              break;
            case 2:
              title = 'Qr-Code';
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  '#000000',
                  'CANCEL',
                  true,
                  ScanMode.QR,
                );

                // Get data dari firebase by product id
                var data = await controller.getProductById(barcode);

                print('datanya disini: $data');

                if (data['error']) {
                  Get.snackbar('Oh Snap!', data['error']);
                } else {
                  Get.toNamed(
                    Routes.DETAIL_PRODUCTS,
                    arguments: data['data'],
                  );
                }
              };
              break;
            case 3:
              title = 'Catalog';
              icon = Icons.document_scanner_outlined;
              onTap = () {
                controller.downloadCatalog();
              };
              break;
            default:
          }

          return Material(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(icon, size: 50),
                  ),
                  const Gap(10),
                  Text(
                    title,
                    style: GoogleFonts.outfit(),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () async {
          Map<String, dynamic> response = await authC.logout();
          if (response['error'] == false) {
            Get.offAllNamed(Routes.LOGIN);
          } else {
            Get.snackbar('Oh Snap!', response['message']);
          }
        },
      ),
    );
  }
}
