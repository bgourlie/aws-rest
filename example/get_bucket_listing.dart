import 'dart:io';
import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';
import 'settings.dart' as settings;

final creds = new AwsCredentials(settings.AWS_ACCESS_KEY_ID, settings.AWS_SECRET_ACCESS_KEY);
final scope = new AwsScope(settings.AWS_REGION, 's3');
final signer = new RequestSigner(creds, scope);

void main(){
  // List objects
  final awsClient = new AwsClient(signer);
  awsClient.get(settings.DOMAIN, '/').then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
    final buffer = new StringBuffer();
    resp.transform(UTF8.decoder).listen((String contents) {
      buffer.write(contents);
    }).onDone(() {
      final xmlText = buffer.toString();
      final resp = new ListBucketResult.fromXml(xmlText);
      resp.contents.forEach((c) => print(c.key));
    });
  });

}
