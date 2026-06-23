class AuthResponseModel {
  final String accessToken;
  AuthResponseModel({required this.accessToken});
  //doc json
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] as Map<String, dynamic>?;

    return AuthResponseModel(accessToken: dataMap?['accessToken'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'access_token': accessToken},
    };
  }
}
