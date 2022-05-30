import 'package:hjnzb/generated/json/base/json_convert_content.dart';
import 'package:hjnzb/generated/sample_user_info_entity.dart';

SampleUserInfoEntity $SampleUserInfoEntityFromJson(Map<String, dynamic> json) {
	final SampleUserInfoEntity sampleUserInfoEntity = SampleUserInfoEntity();
	final String? header = jsonConvert.convert<String>(json['header']);
	if (header != null) {
		sampleUserInfoEntity.header = header;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		sampleUserInfoEntity.username = username;
	}
	final String? memberid = jsonConvert.convert<String>(json['memberid']);
	if (memberid != null) {
		sampleUserInfoEntity.memberid = memberid;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		sampleUserInfoEntity.city = city;
	}
	final String? signature = jsonConvert.convert<String>(json['signature']);
	if (signature != null) {
		sampleUserInfoEntity.signature = signature;
	}
	final int? rank = jsonConvert.convert<int>(json['rank']);
	if (rank != null) {
		sampleUserInfoEntity.rank = rank;
	}
	final int? fansnum = jsonConvert.convert<int>(json['fansnum']);
	if (fansnum != null) {
		sampleUserInfoEntity.fansnum = fansnum;
	}
	final int? attentionnum = jsonConvert.convert<int>(json['attentionnum']);
	if (attentionnum != null) {
		sampleUserInfoEntity.attentionnum = attentionnum;
	}
	final int? sendgiftnum = jsonConvert.convert<int>(json['sendgiftnum']);
	if (sendgiftnum != null) {
		sampleUserInfoEntity.sendgiftnum = sendgiftnum;
	}
	final bool? isAttrntion = jsonConvert.convert<bool>(json['isAttrntion']);
	if (isAttrntion != null) {
		sampleUserInfoEntity.isAttrntion = isAttrntion;
	}
	final bool? banSpeak = jsonConvert.convert<bool>(json['banSpeak']);
	if (banSpeak != null) {
		sampleUserInfoEntity.banSpeak = banSpeak;
	}
	final dynamic? banOpenTime = jsonConvert.convert<dynamic>(json['banOpenTime']);
	if (banOpenTime != null) {
		sampleUserInfoEntity.banOpenTime = banOpenTime;
	}
	final dynamic? banTime = jsonConvert.convert<dynamic>(json['banTime']);
	if (banTime != null) {
		sampleUserInfoEntity.banTime = banTime;
	}
	return sampleUserInfoEntity;
}

Map<String, dynamic> $SampleUserInfoEntityToJson(SampleUserInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['header'] = entity.header;
	data['username'] = entity.username;
	data['memberid'] = entity.memberid;
	data['city'] = entity.city;
	data['signature'] = entity.signature;
	data['rank'] = entity.rank;
	data['fansnum'] = entity.fansnum;
	data['attentionnum'] = entity.attentionnum;
	data['sendgiftnum'] = entity.sendgiftnum;
	data['isAttrntion'] = entity.isAttrntion;
	data['banSpeak'] = entity.banSpeak;
	data['banOpenTime'] = entity.banOpenTime;
	data['banTime'] = entity.banTime;
	return data;
}