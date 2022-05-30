import 'package:hjnzb/generated/json/base/json_convert_content.dart';
import 'package:hjnzb/generated/rank_new_entity.dart';

RankNewEntity $RankNewEntityFromJson(Map<String, dynamic> json) {
	final RankNewEntity rankNewEntity = RankNewEntity();
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		rankNewEntity.userId = userId;
	}
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		rankNewEntity.username = username;
	}
	final String? header = jsonConvert.convert<String>(json['header']);
	if (header != null) {
		rankNewEntity.header = header;
	}
	final int? rank = jsonConvert.convert<int>(json['rank']);
	if (rank != null) {
		rankNewEntity.rank = rank;
	}
	final String? memberid = jsonConvert.convert<String>(json['memberid']);
	if (memberid != null) {
		rankNewEntity.memberid = memberid;
	}
	final int? totalValue = jsonConvert.convert<int>(json['totalValue']);
	if (totalValue != null) {
		rankNewEntity.totalValue = totalValue;
	}
	final bool? attention = jsonConvert.convert<bool>(json['attention']);
	if (attention != null) {
		rankNewEntity.attention = attention;
	}
	return rankNewEntity;
}

Map<String, dynamic> $RankNewEntityToJson(RankNewEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['userId'] = entity.userId;
	data['username'] = entity.username;
	data['header'] = entity.header;
	data['rank'] = entity.rank;
	data['memberid'] = entity.memberid;
	data['totalValue'] = entity.totalValue;
	data['attention'] = entity.attention;
	return data;
}