part of aws_rest;

class RequestPayload {
  static final _emptySha256 = _sha256Payload(new List<int>());
  static final _emptyMd5 = _md5Payload(new List<int>());
  final List<int> bytes;
  final String sha256;
  final String md5;
  final Map<String, String> headers;

  bool get isEmpty => this.bytes == null;

  RequestPayload(this.bytes, this.sha256, this.md5, this.headers);

  factory RequestPayload.fromBytes(List<int> bytes, {Map<String, String> headers}) {
    if(headers == null){
      headers = new Map<String, String>();
    }
    return new RequestPayload(bytes, _sha256Payload(bytes), _md5Payload(bytes), headers);
  }

  factory RequestPayload.empty(){
    return new RequestPayload(null, _emptySha256, _emptyMd5, new Map<String, String>());
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
