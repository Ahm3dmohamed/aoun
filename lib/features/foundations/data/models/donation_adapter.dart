import 'package:aoun/features/foundations/data/models/donation_model.dart';
import 'package:hive/hive.dart';

class DonationModelAdapter extends TypeAdapter<DonationModel> {
  @override
  final int typeId = 2;

  @override
  DonationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DonationModel(
      id: fields[0]?.toString() ?? '',
      foundationId: fields[1]?.toString() ?? '',
      foundationName: fields[2]?.toString() ?? '',
      donorName: fields[3]?.toString() ?? '',
      amount: (fields[4] as num?)?.toDouble() ?? 0.0,
      createdAt: fields[5]?.toString() ?? '',
      purpose: fields[6]?.toString() ?? 'Money',
      details: fields[7]?.toString(),
    );
  }

  @override
  void write(BinaryWriter writer, DonationModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.foundationId)
      ..writeByte(2)
      ..write(obj.foundationName)
      ..writeByte(3)
      ..write(obj.donorName)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.purpose)
      ..writeByte(7)
      ..write(obj.details);
  }
}
