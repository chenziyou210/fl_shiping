import 'package:hjnzb/generated/json/base/json_convert_content.dart';
import 'package:hjnzb/generated/car_list_entity.dart';

CarListEntity $CarListEntityFromJson(Map<String, dynamic> json) {
	final CarListEntity carListEntity = CarListEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		carListEntity.id = id;
	}
	final String? carName = jsonConvert.convert<String>(json['carName']);
	if (carName != null) {
		carListEntity.carName = carName;
	}
	final String? carStaticUrl = jsonConvert.convert<String>(json['carStaticUrl']);
	if (carStaticUrl != null) {
		carListEntity.carStaticUrl = carStaticUrl;
	}
	final String? carGifUrl = jsonConvert.convert<String>(json['carGifUrl']);
	if (carGifUrl != null) {
		carListEntity.carGifUrl = carGifUrl;
	}
	final int? monthPrice = jsonConvert.convert<int>(json['monthPrice']);
	if (monthPrice != null) {
		carListEntity.monthPrice = monthPrice;
	}
	final int? quarterSpecialPrice = jsonConvert.convert<int>(json['quarterSpecialPrice']);
	if (quarterSpecialPrice != null) {
		carListEntity.quarterSpecialPrice = quarterSpecialPrice;
	}
	final int? quarterOriginalPrice = jsonConvert.convert<int>(json['quarterOriginalPrice']);
	if (quarterOriginalPrice != null) {
		carListEntity.quarterOriginalPrice = quarterOriginalPrice;
	}
	final int? yeatSpecialPrice = jsonConvert.convert<int>(json['yearSpecialPrice']);
	if (yeatSpecialPrice != null) {
		carListEntity.yeatSpecialPrice = yeatSpecialPrice;
	}
	final int? yeatOriginalPrice = jsonConvert.convert<int>(json['yearOriginalPrice']);
	if (yeatOriginalPrice != null) {
		carListEntity.yeatOriginalPrice = yeatOriginalPrice;
	}
	final int? created = jsonConvert.convert<int>(json['created']);
	if (created != null) {
		carListEntity.created = created;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		carListEntity.createUser = createUser;
	}
	final int? update = jsonConvert.convert<int>(json['update']);
	if (update != null) {
		carListEntity.update = update;
	}
	final int? state = jsonConvert.convert<int>(json['state']);
	if (state != null) {
		carListEntity.state = state;
	}
	final int? available = jsonConvert.convert<int>(json['available']);
	if (available != null) {
		carListEntity.available = available;
	}
	final String? language = jsonConvert.convert<String>(json['language']);
	if (language != null) {
		carListEntity.language = language;
	}
	final int? carBuyState = jsonConvert.convert<int>(json['carBuyState']);
	if (carBuyState != null) {
		carListEntity.carBuyState = carBuyState;
	}
	final dynamic? validityPeriod = jsonConvert.convert<dynamic>(json['validityPeriod']);
	if (validityPeriod != null) {
		carListEntity.validityPeriod = validityPeriod;
	}
	return carListEntity;
}

Map<String, dynamic> $CarListEntityToJson(CarListEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['carName'] = entity.carName;
	data['carStaticUrl'] = entity.carStaticUrl;
	data['carGifUrl'] = entity.carGifUrl;
	data['monthPrice'] = entity.monthPrice;
	data['quarterSpecialPrice'] = entity.quarterSpecialPrice;
	data['quarterOriginalPrice'] = entity.quarterOriginalPrice;
	data['yearSpecialPrice'] = entity.yeatSpecialPrice;
	data['yearOriginalPrice'] = entity.yeatOriginalPrice;
	data['created'] = entity.created;
	data['createUser'] = entity.createUser;
	data['update'] = entity.update;
	data['state'] = entity.state;
	data['available'] = entity.available;
	data['language'] = entity.language;
	data['carBuyState'] = entity.carBuyState;
	data['validityPeriod'] = entity.validityPeriod;
	return data;
}