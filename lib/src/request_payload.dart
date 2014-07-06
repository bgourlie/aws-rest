part of aws_rest;

class RequestPayload {
  static final _emptySha256 = _sha256Payload(new List<int>());
  static final _emptyMd5 = _md5Payload(new List<int>());
  final ContentType contentType;
  final List<int> bytes;
  final String sha256;
  final String md5;

  bool get isEmpty => this.bytes == null;

  RequestPayload(this.contentType, this.bytes, this.sha256, this.md5);

  factory RequestPayload.fromBytes(List<int> bytes, ContentType contentType) {
    return new RequestPayload(contentType, bytes, _sha256Payload(bytes), _md5Payload(bytes));
  }

  factory RequestPayload.empty(){
    return new RequestPayload(null, null, _emptySha256, _emptyMd5);
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
