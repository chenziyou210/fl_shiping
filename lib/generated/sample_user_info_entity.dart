import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/sample_user_info_entity.g.dart';


@JsonSerializable()
class SampleUserInfoEntity {

	SampleUserInfoEntity();

	factory SampleUserInfoEntity.fromJson(Map<String, dynamic> json) => $SampleUserInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $SampleUserInfoEntityToJson(this);

	String? header;
	String? username;
	String? memberid;
	String? city;
	String? signature;
	int? rank;
	int? fansnum;
	int? attentionnum;
	int? sendgiftnum;
	bool? isAttrntion;
	bool? banSpeak;
	dynamic? banOpenTime;
	dynamic? banTime;
}
