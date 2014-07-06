import 'dart:io';
import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';
import 'settings.dart' as settings;

final creds = new AwsCredentials(settings.AWS_ACCESS_KEY_ID, settings.AWS_SECRET_ACCESS_KEY);
final scope = new AwsScope(settings.AWS_REGION, 's3');
final signer = new RequestSigner(creds, scope);

void main() {
  // Delete an object
  final awsClient = new AwsClient(signer);
  awsClient.delete(settings.DOMAIN, 'hello_from_aws_rest.html').then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
    resp.transform(UTF8.decoder).listen((contents) {
      print(contents);
    });
  });
}
