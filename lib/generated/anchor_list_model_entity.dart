import 'package:hjnzb/generated/json/base/json_field.dart';
import 'package:hjnzb/generated/json/anchor_list_model_entity.g.dart';


@JsonSerializable()
class AnchorListModelEntity {

	AnchorListModelEntity({this.channelName,
		this.chatRoomId,
		this.city,
		this.closeTime,
		this.daXiu,
		this.distance,
		this.heat,
		this.id,
		this.lookLevel,
		this.onlineNum,
		this.openProps,
		this.openTime,
		this.roomCover,
		this.roomTitle,
		this.roomType,
		this.seeTryTime,
		this.sort,
		this.state,
		this.ticketAmount,
		this.ticketTreeFlg,
		this.timeDeduction,
		this.userId,
		this.username});

	factory AnchorListModelEntity.fromJson(Map<String, dynamic> json) => $AnchorListModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $AnchorListModelEntityToJson(this);

	String? channelName;
	String? chatRoomId;
	String? city;
	String? closeTime;
	bool? daXiu;
	double? distance;
	int? heat;
	String? id;
	int? lookLevel;
	int? onlineNum;
	bool? openProps;
	String? openTime;
	String? roomCover;
	String? roomTitle;
	int? roomType;
	int? seeTryTime;
	int? sort;
	int? state;
	double? ticketAmount;
	int? ticketTreeFlg;
	double? timeDeduction;
	String? userId;
	String? username;

}

