import 'dart:typed_data';

class DataModel {
  int? id;
  Uint8List imageBytes;
 
  DataModel({this.id, required this.imageBytes});
 
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'image': imageBytes,
    };
    return map;
  }
 
  DataModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        imageBytes = res["image"];
}