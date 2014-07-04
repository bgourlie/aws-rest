part of aws_rest;

class RequestSigner {
  final AwsCredentials _credentials;
  final AwsScope _scope;

  RequestSigner(this._credentials, this._scope);

  void signRequest(HttpClientRequest req, RequestPayload payload) {
    req.headers.remove('transfer-encoding', 'chunked'); // aws doesn't support this header, dart seems to add it by default

    if (payload != null) {
      req.headers.contentType = payload.contentType;
      req.headers.contentLength = payload != null ? payload.bytes.length : 0;
      req.headers.add('x-amz-content-sha256', payload.hash);
    }

    final reqDate = new DateTime.now().toUtc();
    req.headers.date = reqDate;
    final canonicalRequest = _getCanonicalRequest(req, payload);
    final scope = this._scope.generateScopeString(req);
    final stringToSign = _generateStringToSign(canonicalRequest, scope, reqDate);
    final signingKey = _generateSigningKey();
    final signature = _getSignature(signingKey, stringToSign);
    final signedHeaders = _generateSignedHeaders(req);
    final authHeader = _generateAuthorizationString(scope, signedHeaders, signature);
    req.headers.add('authorization', authHeader);
  }

  static String _getCanonicalRequest(HttpClientRequest req, RequestPayload payload) {

    // HTTPMethod is one of the HTTP methods, for example GET, PUT, HEAD, and DELETE.
    final httpMethod = req.method;

    // CanonicalURI is the URI-encoded version of the absolute path component of the URI—everything starting with the "/" that follows the domain name and up to the end of the string or to the question mark character ('?') if you have query string parameters.
    final canonicalUri = req.uri.path;

    // CanonicalQueryString specifies the URI-encoded query string parameters. You URI-encode name and values individually. You must also sort the parameters in the canonical query string alphabetically by key name. The sorting occurs after encoding. For example, in the URI
    final canonicalQueryString = req.uri.query;

    final canonicalHeaders = _generateCanonicalHeaders(req);
    final signedHeaders = _generateSignedHeaders(req);
    // NOTE: the extra newline between canonical headers and signed headers is not documented (is it right?)
    return '$httpMethod\n$canonicalUri\n$canonicalQueryString\n$canonicalHeaders\n\n$signedHeaders\n${payload.hash}';
  }

  static String _generateCanonicalHeaders(HttpClientRequest req) {
    // CanonicalHeaders is a list of request headers with their values. Individual header name and value pairs are separated by the newline character ("\n"). Header names must be in lowercase. You must sort the header names alphabetically to construct the string, as shown in the following example:
    final headers = new List<String>();
    req.headers.forEach((header, values) => headers.add("${header.toLowerCase()}:${values.join(';').trim()}"));
    headers.sort((str1, str2) => str1.compareTo(str2));
    return headers.join('\n');
  }

  static String _generateSignedHeaders(HttpClientRequest req) {
    final headers = new List<String>();
    req.headers.forEach((header, _) => headers.add(header));
    headers.sort((str1, str2) => str1.compareTo(str2));
    return headers.join(';');
  }

  static String _generateStringToSign(String canonicalRequest, String scope, DateTime reqDate) {
    final iso8601Date = httpDateFormatter.format(reqDate);
    final hashedRequest = _getStringHash(canonicalRequest);
    return 'AWS4-HMAC-SHA256\n$iso8601Date\n$scope\n$hashedRequest';
  }

  List<int> _generateSigningKey() {
    final dateKey = _generateHmac256Hash(UTF8.encode('AWS4${this._credentials.secretAccessKey}'), scopeDateFormatter.format(new DateTime.now().toUtc()));
    final dateRegionKey = _generateHmac256Hash(dateKey, this._scope._region);
    final dateRegionServiceKey = _generateHmac256Hash(dateRegionKey, this._scope._service);
    final signingKey = _generateHmac256Hash(dateRegionServiceKey, "aws4_request");
    return signingKey;
  }

  static String _getSignature(List<int> signingKey, String stringToSign) {
    final signature = _generateHmac256Hash(signingKey, stringToSign);
    return CryptoUtils.bytesToHex(signature);
  }

  static List<int> _generateHmac256Hash(List<int> signingKey, String valueToHash) {
    final hasher = new HMAC(new SHA256(), signingKey);
    hasher.add(UTF8.encode(valueToHash));
    return hasher.close();
  }

  String _generateAuthorizationString(String scope, String signedHeaders, String signature) {
    return 'AWS4-HMAC-SHA256 Credential=${this._credentials.accessKeyId}/$scope,SignedHeaders=$signedHeaders,Signature=$signature';
  }

  static String _getStringHash(String str) {
    final hasher = new SHA256();
    hasher.add(UTF8.encode(str));
    return CryptoUtils.bytesToHex(hasher.close());
  }
}
