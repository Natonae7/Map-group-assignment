import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'team_model.g.dart';

@JsonSerializable()
class TeamModel {
  final String id;
  final String name;
  final String managerId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<String> playerIds;

  TeamModel({
    required this.id,
    required this.name,
    required this.managerId,
    required this.createdAt,
    required this.updatedAt,
    required this.playerIds,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);

  TeamModel copyWith({
    String? id,
    String? name,
    String? managerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? playerIds,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      managerId: managerId ?? this.managerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      playerIds: playerIds ?? this.playerIds,
    );
  }
} 