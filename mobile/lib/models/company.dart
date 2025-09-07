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
      companyName: json['companyName'] ?? json['name'],
      sector: json['sector'],
      industry: json['industry'],
      description: json['description'],
      employees: json['employees'],
      website: json['website'],
      logoUrl: json['logo'] ?? json['logoUrl'],
      iconUrl: json['iconUrl'],
      // Financial fields
      price: (json['price'] ?? json['marketData']?['price'])?.toDouble(),
      mktCap: (json['marketCap'] ?? json['marketData']?['marketCap'])?.toDouble(),
      enterpriseValue:
      (json['enterpriseValue'] ?? json['marketData']?['enterpriseValue'])
          ?.toDouble(),
      sharesOutstanding:
      (json['sharesOutstanding'] ?? json['marketData']?['sharesOutstanding'])
          ?.toDouble(),
      totalAssets: (json['totalAssets'] ?? json['financials']?['totalAssets'])
          ?.toDouble(),
      totalRevenue:
      (json['totalRevenue'] ?? json['financials']?['totalRevenue'])?.toDouble(),
      totalDebt: (json['totalDebt'] ?? json['financials']?['totalDebt'])?.toDouble(),
      cash: (json['cash'] ?? json['financials']?['cash'])?.toDouble(),
      shortTermInvestments: (json['shortTermInvestments'] ??
          json['financials']?['shortTermInvestments'])
          ?.toDouble(),
      accountsReceivable:
      (json['accountsReceivable'] ?? json['financials']?['accountsReceivable'])
          ?.toDouble(),
      interestIncome:
      (json['interestIncome'] ?? json['financials']?['interestIncome'])?.toDouble(),
      shariahCompliant: json['shariahCompliant'] ?? json['shariah']?['compliant'],
    );
  }

}
