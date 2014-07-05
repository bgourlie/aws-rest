import 'dart:io';
import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';
import 'settings.dart' as settings;

final creds = new AwsCredentials(settings.AWS_ACCESS_KEY_ID, settings.AWS_SECRET_ACCESS_KEY);
final scope = new AwsScope(settings.AWS_REGION, 's3');
final signer = new RequestSigner(creds, scope);

void main(){

  // Upload an object
  final awsClient = new AwsClient(signer);
  final payload = new RequestPayload.fromBytes(new ContentType('text', 'html', charset: "utf-8"),
      UTF8.encode("<html><head></head><body><h1>hello from aws_rest!</h1></body></html>"));
  awsClient.put(settings.DOMAIN, 'hello_from_aws_rest.html', payload)
      .then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
    resp.transform(UTF8.decoder).listen((String contents) {
      print(contents);
    });
  });
}
