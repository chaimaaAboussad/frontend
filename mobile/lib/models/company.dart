class Company {
  final String symbol;
  final String? companyName;
  final String? sector;
  final String? industry;
  final String? description;
  final int? employees;
  final String? website;
  final String? logoUrl;
  final String? iconUrl;

  final double? price;
  final double? mktCap;
  final double? totalAssets;
  final double? enterpriseValue;
  final double? sharesOutstanding;

  final double? totalDebt;
  final double? totalRevenue;
  final double? cash;
  final double? shortTermInvestments;
  final double? accountsReceivable;
  final double? interestIncome;

  final bool? shariahCompliant; // backend calculated

  Company({
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

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      symbol: json['symbol'],
      companyName: json['companyName'],
      sector: json['sector'],
      industry: json['industry'],
      description: json['description'],
      employees: json['employees'],
      website: json['website'],
      logoUrl: json['logoUrl'],
      iconUrl: json['iconUrl'],
      price: (json['price'] as num?)?.toDouble(),
      mktCap: (json['mktCap'] as num?)?.toDouble(),
      totalAssets: (json['totalAssets'] as num?)?.toDouble(),
      enterpriseValue: (json['enterpriseValue'] as num?)?.toDouble(),
      sharesOutstanding: (json['sharesOutstanding'] as num?)?.toDouble(),
      totalDebt: (json['totalDebt'] as num?)?.toDouble(),
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
      cash: (json['cash'] as num?)?.toDouble(),
      shortTermInvestments: (json['shortTermInvestments'] as num?)?.toDouble(),
      accountsReceivable: (json['accountsReceivable'] as num?)?.toDouble(),
      interestIncome: (json['interestIncome'] as num?)?.toDouble(),
      shariahCompliant: json['shariahCompliant'],
    );
  }
}
