class ProductModel {
  String docId;
  String code;
  String name;
  int qty;

  ProductModel({
    required this.docId,
    required this.code,
    required this.name,
    required this.qty,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        docId: json["docId"] ?? "",
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        qty: json["qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "code": code,
        "name": name,
        "qty": qty,
      };
}
