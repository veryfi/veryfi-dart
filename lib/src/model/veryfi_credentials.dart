/// Credentials used to authenticate the SDK user.
/// This credentials can be found in https://hub.veryfi.com
class VeryfiCredentials {
  final String clientId;
  final String clientSecret;
  final String username;
  final String apiKey;
  VeryfiCredentials(
      this.clientId, this.clientSecret, this.username, this.apiKey);
}
