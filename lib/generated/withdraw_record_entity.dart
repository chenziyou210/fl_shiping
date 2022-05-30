import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/withdraw_record_entity.g.dart';

@JsonSerializable()
class WithdrawRecordEntity {

	String? accountob;
	int? available;
	String? bankname;
	String? bindBankId;
	String? cardNumber;
	String? created;
	String? examRemark;
	int? examState;
	String? examTime;
	String? examUsername;
	String? id;
	String? modified;
	double? money;
	String? name;
	String? payRemark;
	int? payState;
	String? payTime;
	int? state;
	String? userid;
  
  WithdrawRecordEntity();

  factory WithdrawRecordEntity.fromJson(Map<String, dynamic> json) => $WithdrawRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => $WithdrawRecordEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}