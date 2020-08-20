import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {

  String id;
  String productName;
  double price;
  bool available;
  String photoUrl;

    Product({
        this.id,
        this.productName = '',
        this.price = 0.0,
        this.available = true,
        this.photoUrl,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id          : json["id"],
        productName : json["productName"],
        price       : json["price"],
        available   : json["available"],
        photoUrl    : json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        //"id"         : id,
        "productName": productName,
        "price"      : price,
        "available"  : available,
        "photoUrl"   : photoUrl,
    };
}
