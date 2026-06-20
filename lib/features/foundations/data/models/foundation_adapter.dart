import 'package:aoun/features/foundations/data/models/foundation_model.dart';
import 'package:hive/hive.dart';

class FoundationModelAdapter extends TypeAdapter<FoundationModel> {
  @override
  final int typeId = 1;

  @override
  FoundationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoundationModel(
      id: fields[0]?.toString() ?? '',
      name: fields[1]?.toString() ?? '',
      email: fields[2]?.toString() ?? '',
      phone: fields[3]?.toString() ?? '',
      foundationType: fields[4]?.toString() ?? '',
      donationType: fields[5]?.toString() ?? '',
      location: fields[6]?.toString() ?? '',
      createdAt: fields[7]?.toString() ?? '',
      totalDonations: (fields[8] as num?)?.toDouble() ?? 0.0,
      imageUrl: fields[9]?.toString(),
      description: fields[10]?.toString(),
      targetAmount: (fields[11] as num?)?.toDouble() ?? 800000.0,
      isVerified: fields[12] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, FoundationModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.foundationType)
      ..writeByte(5)
      ..write(obj.donationType)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.totalDonations)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.targetAmount)
      ..writeByte(12)
      ..write(obj.isVerified);
  }
}
