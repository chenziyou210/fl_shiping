import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/bank_list_entity.g.dart';


@JsonSerializable()
class BankListEntity {

	BankListEntity();

	factory BankListEntity.fromJson(Map<String, dynamic> json) => $BankListEntityFromJson(json);

	Map<String, dynamic> toJson() => $BankListEntityToJson(this);

	String? id;
	int? state;
	String? userid;
	String? purseChannel;
	String? name;
	String? bankname;
	String? cardNumber;
	String? accountob;
	String? remark;
	int? available;
	int? created;
	int? modified;
	String? bankIcon;
}
