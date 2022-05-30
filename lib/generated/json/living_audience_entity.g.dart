import 'package:hjnzb/generated/json/base/json_convert_content.dart';
import 'package:hjnzb/generated/living_audience_entity.dart';

LivingAudienceEntity $LivingAudienceEntityFromJson(Map<String, dynamic> json) {
	final LivingAudienceEntity livingAudienceEntity = LivingAudienceEntity();
	final String? header = jsonConvert.convert<String>(json['header']);
	if (header != null) {
		livingAudienceEntity.header = header;
	}
	final String? memberid = jsonConvert.convert<String>(json['memberid']);
	if (memberid != null) {
		livingAudienceEntity.memberid = memberid;
	}
	final int? rank = jsonConvert.convert<int>(json['rank']);
	if (rank != null) {
		livingAudienceEntity.rank = rank;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		livingAudienceEntity.userId = userId;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		livingAudienceEntity.username = username;
	}
	return livingAudienceEntity;
}

Map<String, dynamic> $LivingAudienceEntityToJson(LivingAudienceEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['header'] = entity.header;
	data['memberid'] = entity.memberid;
	data['rank'] = entity.rank;
	data['userId'] = entity.userId;
	data['username'] = entity.username;
	return data;
}