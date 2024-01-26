import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:qr_code/app/data/models/product_model.dart';

import '../controllers/detail_products_controller.dart';

class DetailProductsView extends GetView<DetailProductsController> {
  DetailProductsView({Key? key}) : super(key: key);

  final ProductModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";
    return Scaffold(
        appBar: AppBar(
          title: const Text('DetailProductsView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              height: 150,
              width: 150,
              color: Colors.white,
              alignment: Alignment.center,
              child: Card(elevation: 5, child: QrImageView(data: product.code)),
            ),
            const Gap(20),
            TextField(
              autocorrect: false,
              controller: codeC,
              keyboardType: TextInputType.number,
              maxLength: 10,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Product Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const Gap(20),
            TextField(
              autocorrect: false,
              controller: nameC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const Gap(20),
            TextField(
              autocorrect: false,
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Product Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  controller.isLoading(true);
                  // agar tidak double click
                  // .....

                  if (codeC.text.isNotEmpty &&
                      nameC.text.isNotEmpty &&
                      qtyC.text.isNotEmpty) {
                    Map<String, dynamic> response =
                        await controller.editProduct({
                      'docId': product.docId,
                      'code': codeC.text,
                      'name': nameC.text,
                      'qty': int.tryParse(qtyC.text) ?? 0,
                    });

                    Get.back();

                    Get.snackbar(
                      response['error'] ? 'Error' : 'Success',
                      response['message'],
                    );
                  }
                  controller.isLoading(false);
                } else {
                  Get.snackbar(
                    'Oh Snap!',
                    'Semua data wajib diisi.',
                    duration: const Duration(seconds: 2),
                  );
                }
              },
              child: Obx(() => Text(
                    controller.isLoading.isFalse
                        ? 'UPDATE PRODUCT'
                        : 'Loading...',
                  )),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Delete',
                    middleText: 'are you sure to delete this product ?',
                    actions: [
                      OutlinedButton(
                        onPressed: () => Get.back(),
                        child: Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // delete...
                          if (controller.isLoadingDelete.isFalse) {
                            controller.isLoadingDelete(true);
                            Map<String, dynamic> response =
                                await controller.deleteProduct(product.docId);
                            controller.isLoadingDelete(false);

                            Get.back();
                            Get.back();

                            Get.snackbar(
                              response['error'] ? 'Error' : 'Berhasil',
                              response['message'],
                            );
                          } else {
                            Get.snackbar(
                              'Oh Snap!',
                              'Semua data wajib diisi.',
                              duration: const Duration(seconds: 2),
                            );
                          }
                        },
                        child: Text('CONFIRM'),
                      ),
                    ]);
              },
              child: Text(
                'Delete product',
                style: TextStyle(
                  color: Colors.red.shade900,
                ),
              ),
            ),
          ],
        ));
  }
}
