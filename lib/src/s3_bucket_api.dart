part of aws_rest;

class S3BucketApi {
  final AwsClient _awsClient;
  final String _bucketName;

  S3BucketApi(this._bucketName, this._awsClient);

  get _domain => '${_bucketName}.s3.amazonaws.com';

  Future uploadObjectBytes(String objectKey, List<int> bytes, ContentType contentType) {
    final completer = new Completer();
    final payload = new RequestPayload.fromBytes(contentType, bytes);
    this._awsClient.put(this._domain, objectKey, payload).then((HttpClientResponse resp) {
      if(resp.reasonPhrase.toUpperCase() != 'OK'){
        completer.completeError(resp); //TODO: deserialize error into model some model
      } else {
        completer.complete();
      }
    });
    return completer.future;
  }

  Future<ListBucketResult> listBucket() {
    final completer = new Completer<ListBucketResult>();
    this._awsClient.get(this._domain, '/').then((HttpClientResponse resp) {
      if(resp.reasonPhrase.toUpperCase() != 'OK'){
        completer.completeError(resp); // TODO: deserialize error into model some model
      } else {
        final buffer = new StringBuffer();
        resp.transform(UTF8.decoder).listen((String contents) {
          buffer.write(contents);
        }).onDone(() {
          final xmlText = buffer.toString();
          final results = new ListBucketResult.fromXml(xmlText);
          completer.complete(results);
        });
      }
    });
    return completer.future;
  }

  Future<DeleteResults> deleteObjects(List<S3Object> objects) {
    throw 'not implemented';
  }
}