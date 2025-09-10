import 'package:hive/hive.dart';
import '../company.dart';


part 'company_hive.g.dart';

@HiveType(typeId: 0)
class CompanyHive {
  @HiveField(0)
  String symbol;

  @HiveField(1)
  String? companyName;

  @HiveField(2)
  String? sector;

  @HiveField(3)
  String? industry;

  @HiveField(4)
  String? description;

  @HiveField(5)
  int? employees;

  @HiveField(6)
  String? website;

  @HiveField(7)
  String? logoUrl;

  @HiveField(8)
  String? iconUrl;

  @HiveField(9)
  double? price;

  @HiveField(10)
  double? mktCap;

  @HiveField(11)
  double? totalAssets;

  @HiveField(12)
  double? enterpriseValue;

  @HiveField(13)
  double? sharesOutstanding;

  @HiveField(14)
  double? totalDebt;

  @HiveField(15)
  double? totalRevenue;

  @HiveField(16)
  double? cash;

  @HiveField(17)
  double? shortTermInvestments;

  @HiveField(18)
  double? accountsReceivable;

  @HiveField(19)
  double? interestIncome;

  @HiveField(20)
  bool? shariahCompliant;

  CompanyHive({
    required this.symbol,
    this.companyName,
    this.sector,
    this.industry,
    this.description,
    this.employees,
    this.website,
    this.logoUrl,
    this.iconUrl,
    this.price,
    this.mktCap,
    this.totalAssets,
    this.enterpriseValue,
    this.sharesOutstanding,
    this.totalDebt,
    this.totalRevenue,
    this.cash,
    this.shortTermInvestments,
    this.accountsReceivable,
    this.interestIncome,
    this.shariahCompliant,
  });

  factory CompanyHive.fromCompany(Company company) => CompanyHive(
    symbol: company.symbol,
    companyName: company.companyName,
    sector: company.sector,
    industry: company.industry,
    description: company.description,
    employees: company.employees,
    website: company.website,
    logoUrl: company.logoUrl,
    iconUrl: company.iconUrl,
    price: company.price,
    mktCap: company.mktCap,
    totalAssets: company.totalAssets,
    enterpriseValue: company.enterpriseValue,
    sharesOutstanding: company.sharesOutstanding,
    totalDebt: company.totalDebt,
    totalRevenue: company.totalRevenue,
    cash: company.cash,
    shortTermInvestments: company.shortTermInvestments,
    accountsReceivable: company.accountsReceivable,
    interestIncome: company.interestIncome,
    shariahCompliant: company.shariahCompliant,
  );

  Company toCompany() => Company(
    symbol: symbol,
    companyName: companyName,
    sector: sector,
    industry: industry,
    description: description,
    employees: employees,
    website: website,
    logoUrl: logoUrl,
    iconUrl: iconUrl,
    price: price,
    mktCap: mktCap,
    totalAssets: totalAssets,
    enterpriseValue: enterpriseValue,
    sharesOutstanding: sharesOutstanding,
    totalDebt: totalDebt,
    totalRevenue: totalRevenue,
    cash: cash,
    shortTermInvestments: shortTermInvestments,
    accountsReceivable: accountsReceivable,
    interestIncome: interestIncome,
    shariahCompliant: shariahCompliant,
  );
}
