class FinancialRatios {
  final double? debtRatio;
  final double? interestBearingAssetRatio;
  final double? liquidityRatio;
  final double? impermissibleIncomeRatio;

  FinancialRatios({
    this.debtRatio,
    this.interestBearingAssetRatio,
    this.liquidityRatio,
    this.impermissibleIncomeRatio,
  });

  factory FinancialRatios.fromJson(Map<String, dynamic> json) {
    return FinancialRatios(
      debtRatio: (json['debtRatio'] as num?)?.toDouble(),
      interestBearingAssetRatio: (json['interestBearingAssetRatio'] as num?)?.toDouble(),
      liquidityRatio: (json['liquidityRatio'] as num?)?.toDouble(),
      impermissibleIncomeRatio: (json['impermissibleIncomeRatio'] as num?)?.toDouble(),
    );
  }
}
