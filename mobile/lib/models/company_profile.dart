class CompanyProfile {
  final String symbol;
  final String? companyName;
  final double? price;
  final int? mktCap; // Use mktCap consistently
  final String? sector;
  final String? industry;

  CompanyProfile({
    required this.symbol,
    this.companyName,
    this.price,
    this.mktCap,
    this.sector,
    this.industry,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      symbol: json['symbol'],
      companyName: json['companyName'],
      price: (json['price'] as num?)?.toDouble(),
      mktCap: json['mktCap'] != null ? (json['mktCap'] as num).toInt() : null,
      sector: json['sector'],
      industry: json['industry'],
    );
  }
}
