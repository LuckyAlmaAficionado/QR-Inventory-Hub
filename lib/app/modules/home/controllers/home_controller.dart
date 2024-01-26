import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:qr_code/app/data/models/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> listProduct = <ProductModel>[].obs;

  void downloadCatalog() async {
    //....
    final pdf = pw.Document();

    // ... mengambil documen dari firebase
    listProduct.clear();

    var fetchData = await firestore.collection('products').get();
    fetchData.docs.forEach((element) {
      listProduct.add(ProductModel.fromJson(element.data()));
    });

    // load font secara manual
    var data = await rootBundle.load("assets/fonts/poppins.ttf");

    var myFont = Font.ttf(data);

    tableTitle(String title) => pw.Padding(
          padding: pw.EdgeInsets.all(10),
          child: pw.Text(title,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
              )),
        );

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4, // ukuran kertas Pdf
          build: (context) {
            List<pw.TableRow> allData =
                List.generate(listProduct.length, (index) {
              ProductModel product = listProduct[index];

              return pw.TableRow(
                verticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  tableTitle('${index + 1}'),
                  tableTitle('${product.code}'),
                  tableTitle('${product.name}'),
                  tableTitle('Jumlah: ${product.qty}'),
                  pw.Container(
                    height: 50,
                    width: 50,
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      data: '${index * 34}',
                    ),
                  ),
                ],
              );
            });
            return [
              pw.Center(
                child: pw.Text(
                  'CATALOG PRODUCT',
                  style: pw.TextStyle(
                    font: myFont,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.black,
                  width: 2,
                ),
                children: [
                  pw.TableRow(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      tableTitle('No Barang'),
                      tableTitle('Kode Barang'),
                      tableTitle('Nama Barang'),
                      tableTitle('Jumlah Barang'),
                      tableTitle('Qr Code'),
                    ],
                  ),
                  ...allData
                ],
              ),
            ];
          }),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocument.pdf');

    print(file.path);

    // masukan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }

  Future getProductById(String codeBarang) async {
    print("codeBarang: $codeBarang");
    try {
      var response = await firestore
          .collection('products')
          .where('code', isEqualTo: codeBarang)
          .get();

      print('ini responsenya: $response');

      if (response.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada product ini di database",
        };
      }

      Map<String, dynamic> data = response.docs.first.data();
      return {
        'error': false,
        'message': "Berhasil mendapatkan detail product dari product code ini",
        "data": ProductModel.fromJson(data),
      };
    } catch (e) {
      return {
        'error': true,
        'message': 'Tidak mendapatkan product',
      };
    }
  }
}
