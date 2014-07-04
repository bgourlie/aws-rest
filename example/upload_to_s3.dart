import 'dart:io';
import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';

final creds = new AwsCredentials('your-access-key-id', 'your-secret-access-key');

// Replace 'us-east-1' with whatever region your aws service resides in.  See 
// http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
// for a list of region codes
final scope = new AwsScope('us-east-1', 's3');
final signer = new RequestSigner(creds, scope);

void main(){  
  final payload = new RequestPayload(new ContentType('text', 'html', charset: "utf-8"), 
      UTF8.encode("<html><head></head><body><h1>hello from aws_rest!</h1></body></html>"));
  
  final awsClient = new AwsClient(signer);
  awsClient.put('your-bucket.s3.amazonaws.com', 'newindex.html', payload)
      .then((HttpClientResponse resp) {
    print('AWS Response: ${resp.reasonPhrase}');
  });
}







