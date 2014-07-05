part of aws_rest;

class RequestPayload {
  static final _emptyPayloadHash = _hashPayload(new List<int>());
  final ContentType contentType;
  final List<int> bytes;
  final String hash;
  bool get isEmpty => this.bytes == null;

  RequestPayload(this.contentType, this.bytes, this.hash);

  factory RequestPayload.fromBytes(ContentType contentType, List<int> bytes) {
    return new RequestPayload(contentType, bytes, _hashPayload(bytes));
  }

  factory RequestPayload.empty(){
    return new RequestPayload(null, null, _emptyPayloadHash);
  }

  static String _hashPayload(List<int> payload) {
    final hasher = new SHA256();
    if (payload == null) {
      hasher.add(new List<int>());
    } else {
      hasher.add(payload);
    }

    return CryptoUtils.bytesToHex(hasher.close());
  }
}
