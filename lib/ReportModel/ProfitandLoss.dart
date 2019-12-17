class ProfitandLossReport {
  final double totalSale;
  final double expectedSale;
  final double totalSaleAmount;
  final String realise;
  final String realiseAfterScheme;
  final String saleCostPerLitre;
  final String grossProfitPerLitre;
  final double expensesMain;
  final double expectedExpense;
  final double overBudgetExpense;
  final String expensesPerLitre;
  final String netProfitPerLitre;
  final String netProfit;
  final double budgetAlloted;
  ProfitandLossReport(
      this.totalSale,
      this.expectedSale,
      this.totalSaleAmount,
      this.realise,
      this.realiseAfterScheme,
      this.saleCostPerLitre,
      this.grossProfitPerLitre,
      this.expensesMain,
      this.expectedExpense,
      this.expensesPerLitre,
      this.netProfitPerLitre,
      this.overBudgetExpense,
      this.budgetAlloted,
      this.netProfit);
  ProfitandLossReport.fromJson(Map<String, dynamic> json)
      : totalSale = json['totalSale'],
        expectedSale = json['expectedSale'],
        totalSaleAmount = json['totalSaleAmount'],
        realise = json['realise'].toString(),
        realiseAfterScheme = json['realiseAfterScheme'].toString(),
        saleCostPerLitre = json['saleCostPerLitre'].toString(),
        grossProfitPerLitre = json['grossProfitPerLitre'].toString(),
        expensesMain = json['expensesMain'],
        expectedExpense = json['expectedExpense'],
        expensesPerLitre = json['expensesPerLitre'].toString(),
        netProfitPerLitre = json['netProfitPerLitre'].toString(),
        overBudgetExpense = json['overBudgetExpense'],
        budgetAlloted = json['budgetAlloted'],
        netProfit = json['netProfit'].toString();

  Map<String, dynamic> toJson() => {
        'totalSale': totalSale,
        'expectedSale': expectedSale,
        'totalSaleAmount': totalSaleAmount,
        'realise': realise,
        'realiseAfterScheme': realiseAfterScheme,
        'saleCostPerLitre': saleCostPerLitre,
        'grossProfitPerLitre': grossProfitPerLitre,
        'expensesMain': expensesMain,
        'expectedExpense': expectedExpense,
        'expensesPerLitre': expensesPerLitre,
        'netProfitPerLitre': netProfitPerLitre,
        'overBudgetExpense': overBudgetExpense,
        'budgetAlloted': budgetAlloted,
        'netProfit': netProfit,
      };
}
