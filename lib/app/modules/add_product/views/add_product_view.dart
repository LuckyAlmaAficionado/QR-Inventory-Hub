import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProductView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            maxLength: 10,
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
          const Gap(30),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                // agar tidak double click
                // .....

                if (codeC.text.isNotEmpty &&
                    nameC.text.isNotEmpty &&
                    qtyC.text.isNotEmpty) {
                  controller.isLoading(true);

                  Map<String, dynamic> response = await controller.addProduct({
                    'code': codeC.text,
                    'name': nameC.text,
                    'qty': int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoading(false);

                  Get.back();

                  Get.snackbar(
                    response['error'] ? 'Error' : 'Success',
                    response['message'],
                  );
                }
              } else {
                Get.snackbar('Oh Snap!', 'Email dan password wajib diisi.');
              }
            },
            child: Obx(() => Text(
                  controller.isLoading.isFalse ? 'ADD PRODUCT' : 'Loading...',
                )),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          )
        ],
      ),
    );
  }
}
