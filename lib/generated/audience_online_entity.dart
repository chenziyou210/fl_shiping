import 'dart:convert';
import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/audience_online_entity.g.dart';

@JsonSerializable()
class AudienceOnlineEntity {

  int? adminFlag;
  int? banFlag;
	String? header;
	String? memberid;
	int? rank;
	String? userId;
	String? username;
  
  AudienceOnlineEntity();

  factory AudienceOnlineEntity.fromJson(Map<String, dynamic> json) => $AudienceOnlineEntityFromJson(json);

  Map<String, dynamic> toJson() => $AudienceOnlineEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}