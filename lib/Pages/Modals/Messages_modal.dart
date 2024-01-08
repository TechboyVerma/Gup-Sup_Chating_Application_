class Messages {
  Messages({
    required this.toID,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromID,
    required this.sent,
  });
  late final String toID;
  late final String msg;
  late final String read;
  late final Type type;
  late final String fromID;
  late final String sent;

  Messages.fromJson(Map<String, dynamic> json){
    toID = json['toID'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image :Type.text;
    fromID = json['fromID'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['toID'] = toID;
    _data['msg'] = msg;
    _data['read'] = read;
    _data['type'] = type.name;
    _data['fromID'] = fromID;
    _data['sent'] = sent;
    return _data;
  }

}
  enum Type{text,image}