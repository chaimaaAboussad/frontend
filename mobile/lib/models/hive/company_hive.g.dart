// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyHiveAdapter extends TypeAdapter<CompanyHive> {
  @override
  final int typeId = 0;

  @override
  CompanyHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyHive(
      symbol: fields[0] as String,
      companyName: fields[1] as String?,
      sector: fields[2] as String?,
      industry: fields[3] as String?,
      description: fields[4] as String?,
      employees: fields[5] as int?,
      website: fields[6] as String?,
      logoUrl: fields[7] as String?,
      iconUrl: fields[8] as String?,
      price: fields[9] as double?,
      mktCap: fields[10] as double?,
      totalAssets: fields[11] as double?,
      enterpriseValue: fields[12] as double?,
      sharesOutstanding: fields[13] as double?,
      totalDebt: fields[14] as double?,
      totalRevenue: fields[15] as double?,
      cash: fields[16] as double?,
      shortTermInvestments: fields[17] as double?,
      accountsReceivable: fields[18] as double?,
      interestIncome: fields[19] as double?,
      shariahCompliant: fields[20] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyHive obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.sector)
      ..writeByte(3)
      ..write(obj.industry)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.employees)
      ..writeByte(6)
      ..write(obj.website)
      ..writeByte(7)
      ..write(obj.logoUrl)
      ..writeByte(8)
      ..write(obj.iconUrl)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.mktCap)
      ..writeByte(11)
      ..write(obj.totalAssets)
      ..writeByte(12)
      ..write(obj.enterpriseValue)
      ..writeByte(13)
      ..write(obj.sharesOutstanding)
      ..writeByte(14)
      ..write(obj.totalDebt)
      ..writeByte(15)
      ..write(obj.totalRevenue)
      ..writeByte(16)
      ..write(obj.cash)
      ..writeByte(17)
      ..write(obj.shortTermInvestments)
      ..writeByte(18)
      ..write(obj.accountsReceivable)
      ..writeByte(19)
      ..write(obj.interestIncome)
      ..writeByte(20)
      ..write(obj.shariahCompliant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
