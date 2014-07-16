part of aws_rest;

class AwsRequest {
  static final _emptySha256 = _sha256Payload(new List<int>());
  static final _emptyMd5 = _md5Payload(new List<int>());
  final List<int> bytes;
  final String payloadSha256;
  final String payloadMd5;
  final Map<String, String> headers;

  bool get isEmpty => this.bytes == null;

  AwsRequest(this.bytes, this.payloadSha256, this.payloadMd5, this.headers);

  factory AwsRequest.fromBytes(List<int> bytes, {Map<String, String> headers : const{}}) {
    return new AwsRequest(bytes, _sha256Payload(bytes), _md5Payload(bytes), headers);
  }

  factory AwsRequest.noPayload({Map<String, String> headers : const {}}){
    return new AwsRequest(null, _emptySha256, _emptyMd5, headers);
  }

  static String _md5Payload(List<int> payload) {
    final hasher = new MD5();
    if (payload == null) {
      hasher.add(new List<int>());
    } else {
      hasher.add(payload);
    }

    return CryptoUtils.bytesToBase64(hasher.close());
  }

  static String _sha256Payload(List<int> payload) {
    final hasher = new SHA256();
    if (payload == null) {
      hasher.add(new List<int>());
    } else {
      hasher.add(payload);
    }

    return CryptoUtils.bytesToHex(hasher.close());
  }
}
