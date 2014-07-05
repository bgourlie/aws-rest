import 'dart:io';
import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';

const domain = 'your-bucket-name.s3.amazonaws.com';
final creds = new AwsCredentials('your-access-key-id', 'your-secret-access-key');

// Replace 'us-east-1' with whatever region your aws service resides in.  See 
// http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
// for a list of region codes
final scope = new AwsScope('us-east-1', 's3');
final signer = new RequestSigner(creds, scope);

void main(){

  // Upload an object
  final payload = new RequestPayload.fromBytes(new ContentType('text', 'html', charset: "utf-8"),
      UTF8.encode("<html><head></head><body><h1>hello from aws_rest!</h1></body></html>"));
  
  final awsClient = new AwsClient(signer);
  awsClient.put(domain, 'newindex3.html', payload)
      .then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
  });

  // Delete an object
  awsClient.delete(domain, 'newindex222.html').then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
    resp.transform(UTF8.decoder).listen((contents){
      print(contents);
    });
  });

  // List objects
  awsClient.get(domain, '/').then((HttpClientResponse resp) {
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







