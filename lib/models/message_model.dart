class MessageModel {
  String? title;
  String? message;

  MessageModel({
    required this.title,
    required this.message
  });

  List<MessageModel> listMessage = [];
}