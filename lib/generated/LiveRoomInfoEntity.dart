class LiveRoomInfoEntity {
  int? coins;
  String? header;
  bool? isFollowed;
  int? roomId;
  String? title;
  String? userId;
  String? username;

  LiveRoomInfoEntity(
      {this.coins,
      this.header,
      this.isFollowed,
      this.roomId,
      this.title,
      this.userId,
      this.username});

  LiveRoomInfoEntity.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    header = json['header'];
    isFollowed = json['isFollowed'];
    roomId = json['roomId'];
    title = json['title'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    data['header'] = this.header;
    data['isFollowed'] = this.isFollowed;
    data['roomId'] = this.roomId;
    data['title'] = this.title;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}