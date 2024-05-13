class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] as String;
    about = json['about'] as String;
    name = json['name'] as String;
    createdAt = json['created_at'] as String;
    isOnline = json['is_online'] as bool;
    id = json['id'] as String;
    lastActive = json['last_active'] as String;
    email = json['email'] as String;
    pushToken = json['push_token'] as String;
  }
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
