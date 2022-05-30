import 'package:hjnzb/generated/json/base/json_convert_content.dart';
import 'package:hjnzb/generated/account_detail_entity.dart';

AccountDetailEntity $AccountDetailEntityFromJson(Map<String, dynamic> json) {
	final AccountDetailEntity accountDetailEntity = AccountDetailEntity();
	final String? bizid = jsonConvert.convert<String>(json['bizid']);
	if (bizid != null) {
		accountDetailEntity.bizid = bizid;
	}
	final String? created = jsonConvert.convert<String>(json['created']);
	if (created != null) {
		accountDetailEntity.created = created;
	}
	final double? diamond = jsonConvert.convert<double>(json['diamond']);
	if (diamond != null) {
		accountDetailEntity.diamond = diamond;
	}
	final double? preferentialMoney = jsonConvert.convert<double>(json['preferentialMoney']);
	if (preferentialMoney != null) {
		accountDetailEntity.preferentialMoney = preferentialMoney;
	}
	final int? specificType = jsonConvert.convert<int>(json['specificType']);
	if (specificType != null) {
		accountDetailEntity.specificType = specificType;
	}
	final String? specificTypeStr = jsonConvert.convert<String>(json['specificTypeStr']);
	if (specificTypeStr != null) {
		accountDetailEntity.specificTypeStr = specificTypeStr;
	}
	return accountDetailEntity;
}

Map<String, dynamic> $AccountDetailEntityToJson(AccountDetailEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['bizid'] = entity.bizid;
	data['created'] = entity.created;
	data['diamond'] = entity.diamond;
	data['preferentialMoney'] = entity.preferentialMoney;
	data['specificType'] = entity.specificType;
	data['specificTypeStr'] = entity.specificTypeStr;
	return data;
}