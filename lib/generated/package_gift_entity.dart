import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/package_gift_entity.g.dart';

@JsonSerializable()
class PackageGiftEntity {

	dynamic id;
	String? bagpackGiftId;
	String? userId;
	String? giftId;
	String? giftName;
	String? giftImg;
	String? giftGifUrl;
	int? remainQuantity;
  
  PackageGiftEntity();

  factory PackageGiftEntity.fromJson(Map<String, dynamic> json) => $PackageGiftEntityFromJson(json);

  Map<String, dynamic> toJson() => $PackageGiftEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}