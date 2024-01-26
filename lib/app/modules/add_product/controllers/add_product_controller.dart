import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      CollectionReference ref = await firestore.collection('products');
      final docId = await ref.doc().id;
      data.addAll({
        'docId': docId,
      });
      await ref.doc(docId).set(data);

      return {
        'error': false,
        'message': 'Berhasil menambah product',
      };
    } catch (e) {
      print(e);
      return {
        'error': true,
        'message': 'Tidak dapat menambah product',
      };
    }
  }
}
