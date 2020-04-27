
// Code has been lifted from: https://medium.com/flutter-community/implementing-firebase-github-authentication-in-flutter-1c49a172c648
// With respect and credit to Ugurcan Yildirim

//GITHUB REQUEST-RESPONSE MODELS
class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest({this.clientId, this.clientSecret, this.code});

  dynamic toJson() => {
    'client_id': clientId,
    'client_secret': clientSecret,
    'code': code,
  };
}

class GitHubLoginResponse {
  String accessToken;
  String tokenType;
  String scope;

  GitHubLoginResponse({this.accessToken, this.tokenType, this.scope});

  factory GitHubLoginResponse.fromJson(Map<String, dynamic> json) =>
      GitHubLoginResponse(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        scope: json['scope'],
      );
}
