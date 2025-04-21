import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';

class GlobalUserDetailsData {
  int? id;
  String? act;
  GlobalKYCForm? formData;
  String? createdAt;
  String? updatedAt;

  GlobalUserDetailsData({
    this.id,
    this.act,
    this.formData,
    this.createdAt,
    this.updatedAt,
  });

  factory GlobalUserDetailsData.fromJson(Map<String, dynamic> json) {
    return GlobalUserDetailsData(
      id: json["id"],
      act: json["act"],
      formData: json["form_data"] == null
          ? null
          : GlobalKYCForm.fromJson(json["form_data"]),
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "act": act,
        "form_data": formData,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}
