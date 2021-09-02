import 'package:journeyhazard/core/models/base_model.dart';

class EmptyResultModel extends BaseModel {
  EmptyResultModel();

  factory EmptyResultModel.frommJson(json) => EmptyResultModel();
}

class RemoteResultModel<Data> extends BaseModel {
  final Data data;
  final String message;
  final bool flag;
  RemoteResultModel({this.data,  this.message, this.flag});
  factory RemoteResultModel.fromJson(Map<String, dynamic> json) {
    return RemoteResultModel(
      data: json['data'],
      message: json['message'],
      flag: json['flag'],
    );
  }
}

