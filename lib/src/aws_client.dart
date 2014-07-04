part of aws_rest;

class AwsClient {
  final RequestSigner _signer;
  final HttpClient _httpClient;

  AwsClient(this._signer) : this._httpClient = new HttpClient();

  Future<HttpClientResponse> put(String host, String path, RequestPayload payload) {
    final completer = new Completer<HttpClientResponse>();
    this._httpClient.put(host, 80, path).then((HttpClientRequest req) {
      this._signer.signRequest(req, payload);
      req.add(payload.bytes);
      req.close().then((HttpClientResponse resp) => completer.complete(resp));
    });

    return completer.future;
  }
}
