import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/charge_record_entity.g.dart';

@JsonSerializable()
class ChargeRecordEntity {

	String? createTime;
	String? id;
	double? money;
	String? paySource;
	int? payStatus;
	String? remark;
  
  ChargeRecordEntity();

  factory ChargeRecordEntity.fromJson(Map<String, dynamic> json) => $ChargeRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => $ChargeRecordEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}