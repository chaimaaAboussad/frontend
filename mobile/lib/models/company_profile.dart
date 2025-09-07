class CompanyProfile {
  final String symbol;
  final String? companyName;
  final double? price;
  final int? mktCap; // Use mktCap consistently
  final String? sector;
  final String? industry;
  final String? logoUrl;
  final String? website;

  // Financials
  final double? enterpriseValue;
  final double? sharesOutstanding;
  final double? totalAssets;
  final double? totalRevenue;
  final double? totalDebt;
  final double? cash;
  final double? shortTermInvestments;
  final double? accountsReceivable;
  final double? interestIncome;

  // Shariah compliance
  final bool? shariahCompliant;

  CompanyProfile({
    required this.symbol,
    this.companyName,
    this.price,
    this.mktCap,
    this.sector,
    this.industry,
    this.logoUrl,
    this.website,
    this.enterpriseValue,
    this.sharesOutstanding,
    this.totalAssets,
    this.totalRevenue,
    this.totalDebt,
    this.cash,
    this.shortTermInvestments,
    this.accountsReceivable,
    this.interestIncome,
    this.shariahCompliant,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      symbol: json['symbol'],
      companyName: json['companyName'],
      price: (json['price'] as num?)?.toDouble(),
      mktCap: json['mktCap'] != null ? (json['mktCap'] as num).toInt() : null,
      sector: json['sector'],
      industry: json['industry'],
      logoUrl: json['logoUrl'],
      website: json['website'],
      enterpriseValue: (json['enterpriseValue'] as num?)?.toDouble(),
      sharesOutstanding: (json['sharesOutstanding'] as num?)?.toDouble(),
      totalAssets: (json['totalAssets'] as num?)?.toDouble(),
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
      totalDebt: (json['totalDebt'] as num?)?.toDouble(),
      cash: (json['cash'] as num?)?.toDouble(),
      shortTermInvestments: (json['shortTermInvestments'] as num?)?.toDouble(),
      accountsReceivable: (json['accountsReceivable'] as num?)?.toDouble(),
      interestIncome: (json['interestIncome'] as num?)?.toDouble(),
      shariahCompliant: json['shariahCompliant'] as bool?,
    );
  }
}
