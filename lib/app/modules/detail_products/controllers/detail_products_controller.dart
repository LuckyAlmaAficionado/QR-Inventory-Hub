import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingDelete = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> editProduct(Map<String, Object> data) async {
    try {
      await firestore.collection('products').doc("${data["docId"]}").update({
        "name": data['name'],
        "qty": data['qty'],
      });

      return {
        'error': false,
        'message': 'Berhasil mengupdate product',
      };
    } catch (e) {
      return {
        'error': true,
        'message': 'Tidak dapat mengupdate product',
      };
    }
  }

  deleteProduct(String docId) async {
    try {
      await firestore.collection('products').doc(docId).delete();
      return {
        'error': false,
        'message': 'Berhasil menghapus product',
      };
    } catch (e) {
      return {
        'error': true,
        'message': 'Tidak dapat menghapus product',
      };
    }
  }
}
