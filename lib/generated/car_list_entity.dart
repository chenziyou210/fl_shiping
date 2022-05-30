import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/car_list_entity.g.dart';

@JsonSerializable()
class CarListEntity {

	late int id;
	late String carName;
	late String carStaticUrl;
	late String carGifUrl;
	late int monthPrice;
	late int quarterSpecialPrice;
	late int quarterOriginalPrice;
	late int yeatSpecialPrice;
	late int yeatOriginalPrice;
	late int created;
	late String createUser;
	late int update;
	late int state;
	late int available;
	late String language;
	late int carBuyState;
	late dynamic validityPeriod;
  
  CarListEntity();

  factory CarListEntity.fromJson(Map<String, dynamic> json) => $CarListEntityFromJson(json);

  Map<String, dynamic> toJson() => $CarListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}