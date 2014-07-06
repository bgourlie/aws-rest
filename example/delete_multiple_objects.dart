import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:aws_rest/aws_rest.dart';
import 'settings.dart' as settings;

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
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  final logger = new Logger('upload_object_example');
  final creds = new AwsCredentials(settings.AWS_ACCESS_KEY_ID, settings.AWS_SECRET_ACCESS_KEY);
  final scope = new AwsScope(settings.AWS_REGION, 's3');
  final signer = new RequestSigner(creds, scope);
  final awsClient = new AwsClient(signer);
  final bucketApi = new S3BucketApi(settings.S3_BUCKET, awsClient);

  bucketApi.listBucket().then((ListBucketResult res){
    bucketApi.deleteObjects(res.contents).then((DeleteResults delResults){
      logger.fine('delete bucket complete');
    });
  });
}
