part of aws_rest;

class AwsClient {
  final RequestSigner _signer;
  final HttpClient _httpClient;

  AwsClient(this._signer) : this._httpClient = new HttpClient();

  Future<HttpClientResponse> put(Uri uri, RequestPayload payload) => this.sendRequest('put', uri, payload);

  Future<HttpClientResponse> get(Uri uri ) => this.sendRequest('get', uri, new RequestPayload.empty());

  Future<HttpClientResponse> post(Uri uri, RequestPayload payload) => this.sendRequest('post', uri, payload);

  Future<HttpClientResponse> delete(Uri uri, String path) => this.sendRequest('delete', uri, new RequestPayload.empty());

  Future<HttpClientResponse> sendRequest(String method, Uri uri, RequestPayload payload) {
    final completer = new Completer<HttpClientRequest>();
    _logger.finest('Making ${method.toUpperCase()} request to $uri');
    this._httpClient.openUrl(method, uri).then((HttpClientRequest req) {
      this._signer.signRequest(req, payload);
      if (!payload.isEmpty) {
        req.add(payload.bytes);
      }
      req.close().then((HttpClientResponse resp) {
        _logger.finest('Received response: ${resp.reasonPhrase}');
        completer.complete(resp);
      });
    });

    return completer.future;
  }
}
