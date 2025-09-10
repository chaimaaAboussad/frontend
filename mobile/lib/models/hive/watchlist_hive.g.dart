// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistHiveAdapter extends TypeAdapter<WatchlistHive> {
  @override
  final int typeId = 3;

  @override
  WatchlistHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistHive(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
