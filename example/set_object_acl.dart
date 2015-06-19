import 'dart:convert';
import 'package:aws_rest/aws_rest.dart';
import 'package:logging/logging.dart';
import 'settings.dart' as settings;

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord
      .listen((LogRecord r) => print('[${r.loggerName}] ${r.message}'));
  final logger = new Logger('upload_object_example');
  final creds = new AwsCredentials(
      settings.AWS_ACCESS_KEY_ID, settings.AWS_SECRET_ACCESS_KEY);
  final scope = new AwsScope(settings.AWS_REGION, 's3');
  final signer = new RequestSigner(creds, scope);
  final awsClient = new AwsClient(signer);
  final bucketApi = new S3BucketApi(settings.S3_BUCKET, awsClient);

  bucketApi.setCannedAcl('hello-from-bucket-api.html', 'public-read').then((_) {
    logger.fine('set acl complete!');
  });
}
