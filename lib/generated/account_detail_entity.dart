import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/account_detail_entity.g.dart';

@JsonSerializable()
class AccountDetailEntity {

	String? bizid;
	String? created;
	double? diamond;
  double? preferentialMoney;
	int? specificType;
	String? specificTypeStr;
  
  AccountDetailEntity();

  factory AccountDetailEntity.fromJson(Map<String, dynamic> json) => $AccountDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => $AccountDetailEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}