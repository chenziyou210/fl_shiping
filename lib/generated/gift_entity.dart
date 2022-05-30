import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/gift_entity.g.dart';


@JsonSerializable()
class GiftEntity {

	GiftEntity();

	factory GiftEntity.fromJson(Map<String, dynamic> json) => $GiftEntityFromJson(json);

	Map<String, dynamic> toJson() => $GiftEntityToJson(this);

	String? id;
	String? coins;
	String? name;
	String? picurl;
}
