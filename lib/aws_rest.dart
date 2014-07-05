library aws_rest;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:xml/xml.dart' as xml;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

part 'src/request_payload.dart';
part 'src/request_signer.dart';
part 'src/aws_scope.dart';
part 'src/aws_credentials.dart';
part 'src/aws_client.dart';
part 'src/models/list_bucket_result.dart';
part 'src/models/content.dart';
part 'src/models/owner.dart';

final _scopeDateFormatter = new DateFormat('yyyyMMdd');
final _httpDateFormatter = new DateFormat("EEE, dd MMM y HH:mm:ss 'GMT'");
