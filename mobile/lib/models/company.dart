class Company {
  final String symbol;
  final String? name;
  final String? sector;
  final String? industry;
  final double? currentPrice;
  final double? totalDebt;
  final double? totalRevenue;
  final double? enterpriseValue;
  final double? sharesOutstanding;
  final int? halalScore;
  final bool? shariahCompliant;
  final int? marketCap;
  final double? price;
  final double? change;

  Company({
    required this.symbol,
    this.name,
    this.sector,
    this.industry,
    this.currentPrice,
    this.totalDebt,
    this.totalRevenue,
    this.enterpriseValue,
    this.sharesOutstanding,
    this.halalScore,
    this.shariahCompliant,
    this.marketCap,
    this.price,
    this.change,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      symbol: json['symbol'],
      name: json['companyName'] ?? json['name'],
      sector: json['sector'],
      industry: json['industry'],
      currentPrice: json['currentPrice'] != null ? (json['currentPrice'] as num).toDouble() : null,
      totalDebt: json['totalDebt'] != null ? (json['totalDebt'] as num).toDouble() : null,
      totalRevenue: json['totalRevenue'] != null ? (json['totalRevenue'] as num).toDouble() : null,
      enterpriseValue: json['enterpriseValue'] != null ? (json['enterpriseValue'] as num).toDouble() : null,
      sharesOutstanding: json['sharesOutstanding'] != null ? (json['sharesOutstanding'] as num).toDouble() : null,
      halalScore: json['halalScore'],
      shariahCompliant: json['shariahCompliant'],
      marketCap: json['marketCap'] != null ? (json['marketCap'] as num).toInt() : null,
      price: json['currentPrice'] != null ? (json['currentPrice'] as num).toDouble() : null,
      change: json['changePercent'] != null ? (json['changePercent'] as num).toDouble() : null,
    );
  }
}
