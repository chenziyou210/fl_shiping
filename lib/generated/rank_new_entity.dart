import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/rank_new_entity.g.dart';


@JsonSerializable()
class RankNewEntity {

	RankNewEntity();

	factory RankNewEntity.fromJson(Map<String, dynamic> json) => $RankNewEntityFromJson(json);

	Map<String, dynamic> toJson() => $RankNewEntityToJson(this);

	String? userId;
	String? username;
	String? header;
	int? rank;
	String? memberid;
	int? totalValue;
	bool? attention;
}
