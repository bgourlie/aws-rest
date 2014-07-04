part of aws_rest;

class RequestPayload {
  final ContentType contentType;
  final List<int> bytes;
  final String hash;

  RequestPayload(this.contentType, List<int> bytes)
      : this.bytes = bytes,
        hash = _hashPayload(bytes);

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
