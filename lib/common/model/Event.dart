import 'package:xc_deploy_app/common/model/EventPayload.dart';
import 'package:xc_deploy_app/common/model/Repository.dart';
import 'package:xc_deploy_app/common/model/User.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by guoshuyu
 * Date: 2018-07-31
 */

part 'Event.g.dart';

@JsonSerializable()
class Event extends Object with _$EventSerializerMixin {
  String id;
  String type;
  User actor;
  Repository repo;
  User org;
  EventPayload payload;
  @JsonKey(name: "public")
  bool isPublic;
  @JsonKey(name: "created_at")
  DateTime createdAt;

  Event(
    this.id,
    this.type,
    this.actor,
    this.repo,
    this.org,
    this.payload,
    this.isPublic,
    this.createdAt,
  );

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
