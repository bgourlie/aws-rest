import 'dart:io';
import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';
import 'settings.dart' as settings;

final creds = new AwsCredentials(settings.AWS_ACCESS_KEY_ID, settings.AWS_SECRET_ACCESS_KEY);
final scope = new AwsScope(settings.AWS_REGION, 's3');
final signer = new RequestSigner(creds, scope);

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
// WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
// WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
// WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// RUNNING THIS SCRIPT WILL DELETE ALL OBJECTS (up to 1000) IN YOUR BUCKET. DO NOT ACTUALLY RUN THIS SCRIPT IF YOU
// DON'T WANT TO DELETE ALL YOUR OBJECTS.
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
void main(){
  // Delete an object
  final awsClient = new AwsClient(signer);
  final payload = new RequestPayload.empty();

  awsClient.post(settings.DOMAIN, '?delete', payload).then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
    resp.transform(UTF8.decoder).listen((contents){
      print(contents);
    });
  });
}
