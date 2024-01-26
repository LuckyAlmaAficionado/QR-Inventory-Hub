import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/product_model.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PRODUCTS'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.streamProduct(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No products'),
                );
              }

              List<ProductModel> allProducts = [];
              snapshot.data!.docs.forEach(
                  (e) => allProducts.add(ProductModel.fromJson(e.data())));

              return ListView.builder(
                itemCount: allProducts.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  ProductModel products = allProducts[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.DETAIL_PRODUCTS,
                          arguments: products,
                        );
                      },
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    products.code,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(products.name),
                                  Text('Jumlah: ${products.qty}'),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: QrImageView(
                                data: products.code,
                                size: 200.0,
                                version: QrVersions.auto,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
