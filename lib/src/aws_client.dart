part of aws_rest;

class AwsClient {
  final RequestSigner _signer;
  final HttpClient _httpClient;

  AwsClient(this._signer) : this._httpClient = new HttpClient();

  Future<HttpClientResponse> put(String host, String path, RequestPayload payload) => this.sendRequest('put', host, path, payload);

  Future<HttpClientResponse> get(String host, String path) => this.sendRequest('get', host, path, new RequestPayload.empty());

  Future<HttpClientResponse> post(String host, String path, RequestPayload payload) => this.sendRequest('post', host, path, payload);

  Future<HttpClientResponse> delete(String host, String path) => this.sendRequest('delete', host, path, new RequestPayload.empty());

  Future<HttpClientResponse> sendRequest(String method, String host, String path, RequestPayload payload) {
    final completer = new Completer<HttpClientRequest>();
    this._httpClient.open(method, host, 80, path).then((HttpClientRequest req) {
      this._signer.signRequest(req, payload);
      if (!payload.isEmpty) {
        req.add(payload.bytes);
      }
      req.close().then((HttpClientResponse resp) => completer.complete(resp));
    });

    return completer.future;
  }
}
