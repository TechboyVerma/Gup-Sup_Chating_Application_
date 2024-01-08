class ChatUser {
  ChatUser({
    required this.id,
    required this.profilePic,
    required this.about,
    required this.fullName,
    required this.created_at,
    required this.isOnline,
    required this.last_active,
    required this.email,
    required this.push_token
  });
  late  String id;
  late  String profilePic;
  late  String about;
  late  String fullName;
  late  String created_at;
  late  bool isOnline;
  late  String last_active;
  late  String email;
  late  String push_token;

  ChatUser.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    profilePic = json['profilePic']?? '';
    about = json['about']?? '';
    fullName = json['fullName']?? '';
    created_at = json['created_at']?? '';
    isOnline = json['is_online']?? '';
    last_active = json['last_active']?? '';
    email = json['email']?? '';
    push_token = json['push_token']??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['profilePic'] = profilePic;
    data['about'] = about;
    data['fullName'] = fullName;
    data['created_at'] = created_at;
    data['is_online'] = isOnline;
    data['last_active'] = last_active;
    data['email'] = email;
    data['push_token'] =  push_token;
    return data;
  }
}