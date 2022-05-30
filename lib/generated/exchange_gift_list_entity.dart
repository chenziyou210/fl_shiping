import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/exchange_gift_list_entity.g.dart';

@JsonSerializable()
class ExchangeGiftListEntity {

	String? id;
	int? point;
	String? name;
	String? picUrl;
  
  ExchangeGiftListEntity();

  factory ExchangeGiftListEntity.fromJson(Map<String, dynamic> json) => $ExchangeGiftListEntityFromJson(json);

  Map<String, dynamic> toJson() => $ExchangeGiftListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}