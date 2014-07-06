part of aws_rest;

class S3BucketApi {
  final AwsClient _awsClient;
  final String _bucketName;

  S3BucketApi(this._bucketName, this._awsClient);

  get _domain => '${_bucketName}.s3.amazonaws.com';

  Future uploadObjectBytes(String objectKey, List<int> bytes, ContentType contentType, {String contentEncoding: null}) {
    final completer = new Completer();
    final payload = new RequestPayload.fromBytes(bytes, contentType, contentEncoding: contentEncoding);
    final uri = this._getUri(path: objectKey);
    this._awsClient.put(uri, payload).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((responseText) {
        if (resp.reasonPhrase.toUpperCase() != 'OK') {
          _handleError(responseText, completer);
        } else {
          completer.complete();
        }
      });
    });
    return completer.future;
  }

  Future<ListBucketResult> listBucket() {
    final completer = new Completer<ListBucketResult>();
    final uri = this._getUri();
    this._awsClient.get(uri).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((String responseText) {
        if (resp.reasonPhrase.toUpperCase() != 'OK') {
          _handleError(responseText, completer);
        } else {
          final results = new ListBucketResult.fromXml(responseText);
          completer.complete(results);
        }
      });
    });
    return completer.future;
  }

  Future<DeleteResults> deleteObjects(List<S3Object> objects) {
    if (objects == null || objects.length == 0) {
      _logger.warning('No objects were passed to deleteObjects, returning.');
      return new Future(() => new DeleteResults());
    }

    final completer = new Completer<DeleteResults>();
    final deleteReq = new _DeleteRequest(objects);
    final requestXml = deleteReq.toString();
    _logger.finest(requestXml);
    final uri = this._getUri(queryParams: {
        'delete' : ''
    });
    final payload = new RequestPayload.fromBytes(UTF8.encode(requestXml), new ContentType('text', 'xml'));
    this._awsClient.post(uri, payload).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((responseText) {
        if (resp.reasonPhrase.toUpperCase() != 'OK') {
          _handleError(responseText, completer);
        } else {
          _logger.fine(responseText);
          final results = new DeleteResults.fromXml(responseText);
          completer.complete(results);
        }
      });
    });
    return completer.future;
  }

  Uri _getUri({String path, Map<String, String> queryParams}) => new Uri(scheme: 'https', host: this._domain, path: path == null ? '/' : path, queryParameters: queryParams);

  static Future<String> _readResponseAsString(HttpClientResponse resp) {
    final completer = new Completer<String>();
    final buffer = new StringBuffer();
    resp.transform(UTF8.decoder).listen((String contents) => buffer.write(contents)).onDone(() => completer.complete(buffer.toString()));
    return completer.future;
  }

  static void _handleError(String responseText, Completer completer) {
    final err = new ErrorResponse.fromXml(responseText);
    _logger.warning(err.message);
    completer.completeError(err);
  }
}