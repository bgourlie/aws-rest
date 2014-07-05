library aws_rest;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

part 'src/request_payload.dart';
part 'src/request_signer.dart';
part 'src/aws_scope.dart';
part 'src/aws_credentials.dart';
part 'src/aws_client.dart';

final _scopeDateFormatter = new DateFormat('yyyyMMdd');
final _httpDateFormatter = new DateFormat("EEE, dd MMM y HH:mm:ss 'GMT'");
