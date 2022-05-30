import 'package:hjnzb/generated/json/base/json_convert_content.dart';
import 'package:hjnzb/generated/gift_entity.dart';

GiftEntity $GiftEntityFromJson(Map<String, dynamic> json) {
	final GiftEntity giftEntity = GiftEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		giftEntity.id = id;
	}
	final String? coins = jsonConvert.convert<String>(json['coins']);
	if (coins != null) {
		giftEntity.coins = coins;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		giftEntity.name = name;
	}
	final String? picurl = jsonConvert.convert<String>(json['picurl']);
	if (picurl != null) {
		giftEntity.picurl = picurl;
	}
	return giftEntity;
}

Map<String, dynamic> $GiftEntityToJson(GiftEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['coins'] = entity.coins;
	data['name'] = entity.name;
	data['picurl'] = entity.picurl;
	return data;
}