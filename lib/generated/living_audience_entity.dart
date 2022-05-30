import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/living_audience_entity.g.dart';


@JsonSerializable()
class LivingAudienceEntity {

	LivingAudienceEntity();

	factory LivingAudienceEntity.fromJson(Map<String, dynamic> json) => $LivingAudienceEntityFromJson(json);

	Map<String, dynamic> toJson() => $LivingAudienceEntityToJson(this);

	String? header;
	String? memberid;
	int? rank;
	String? userId;
	String? username;
}
