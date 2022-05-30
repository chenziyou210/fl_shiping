import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/bet_record_entity.g.dart';

@JsonSerializable()
class BetRecordEntity {

	String? available;
	String? betJson;
	double? coins;
	String? created;
	double? gainMoney;
	String? gameName;
	int? id;
	String? liveRoomId;
	String? periodTime;
	String? userid;
  int? settlement;
  @JSONField(deserialize: false, serialize: false)
  Map<String, dynamic>? bets;
  BetRecordEntity();

  factory BetRecordEntity.fromJson(Map<String, dynamic> json) => $BetRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => $BetRecordEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}