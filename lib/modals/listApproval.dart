class ListApproval {
  final double applicationAmount;
  final dynamic customerNo;
  final dynamic customerName;
  final dynamic applicationDate;
  final dynamic loanApprovalApplicationNo;
  final dynamic creditRiskRatingGrade;
  final dynamic currencyCode;
  //
  final double cbcFee;
  final dynamic loanTermTypeCode;
  final dynamic firstInterestPaymentDate;
  final dynamic collateralLoanRatio;
  final dynamic collateralLoanYn;
  final dynamic loanExpiryDate;
  final dynamic loanApplicationKindCode;

  final dynamic fireInsuranceExpiryDate;
  final dynamic productName;
  final dynamic houseCorporationTypeCode;
  final dynamic applicationBranchCode;
  final dynamic cBCReferenceNo;
  final dynamic overdueGracePeriodDays;

  final dynamic loanFundPurposeCode;
  final dynamic totalDebtPrincipalInterestAmountRatio;
  final dynamic interestExemptionPeriod;
  final dynamic loanApplicationProgressStatusCode;
  final dynamic creditRiskRatingScore;
  final dynamic loanFundPurposeAmount;

  final dynamic unUseFee;
  final dynamic loanAuthorityCode;
  final dynamic loanPeriodMonthlyCount;
  final dynamic loanFundPurposeAmount3;
  final dynamic monthRepayAmount;

  final dynamic loanFundPurposeAmount2;
  final dynamic overdueYN;
  final dynamic remark4;
  final dynamic loanGracePeriodMonths;
  final dynamic creditBureauCombodiaGrade;

  final dynamic fundSourceCode;
  final dynamic calculationCollateralLoanRatio;
  final dynamic remark2;
  final dynamic creditBureauCombodiaScore;

  final dynamic loanProductCode;
  final dynamic loanCounselNo;
  final dynamic statusCD;
  final dynamic fireInsuranceAmount;

  final dynamic applicationHandlerEmployeeNo;
  final dynamic linkTransactionYN;
  final dynamic loanFundPurposeCode3;
  final dynamic loanHopeDate;

  final dynamic loanFundPurposeCode2;
  final dynamic employeeName1;
  final dynamic frequencyTypeCode;
  final dynamic grid01Count;

  final dynamic fireInsuranceTargetYN;
  final dynamic branchName;
  final dynamic principalRepayMethodCode;
  final dynamic cBCKScore;

  final dynamic handleFee;
  final dynamic feeTypeCode;
  final dynamic loanApplicationTypeCode;
  final dynamic applyInterestRate;
  final dynamic paymentCycleMonthly;
  final dynamic checkCollectionAmount;
  //

  ListApproval({
    this.applicationAmount,
    this.customerNo,
    this.customerName,
    this.applicationDate,
    this.loanApprovalApplicationNo,
    this.creditRiskRatingGrade,
    this.currencyCode,
    //
    this.cbcFee,
    this.loanTermTypeCode,
    this.firstInterestPaymentDate,
    this.collateralLoanRatio,
    this.collateralLoanYn,
    this.loanExpiryDate,
    this.loanApplicationKindCode,
    this.fireInsuranceExpiryDate,
    this.productName,
    this.houseCorporationTypeCode,
    this.applicationBranchCode,
    this.cBCReferenceNo,
    this.overdueGracePeriodDays,
    this.loanFundPurposeCode,
    this.totalDebtPrincipalInterestAmountRatio,
    this.interestExemptionPeriod,
    this.loanApplicationProgressStatusCode,
    this.creditRiskRatingScore,
    this.loanFundPurposeAmount,
    this.unUseFee,
    this.loanAuthorityCode,
    this.loanPeriodMonthlyCount,
    this.loanFundPurposeAmount3,
    this.monthRepayAmount,
    this.loanFundPurposeAmount2,
    this.overdueYN,
    this.remark4,
    this.loanGracePeriodMonths,
    this.creditBureauCombodiaGrade,
    this.fundSourceCode,
    this.calculationCollateralLoanRatio,
    this.remark2,
    this.creditBureauCombodiaScore,
    this.loanProductCode,
    this.loanCounselNo,
    this.statusCD,
    this.fireInsuranceAmount,
    this.applicationHandlerEmployeeNo,
    this.linkTransactionYN,
    this.loanFundPurposeCode3,
    this.loanHopeDate,
    this.loanFundPurposeCode2,
    this.employeeName1,
    this.frequencyTypeCode,
    this.grid01Count,
    this.fireInsuranceTargetYN,
    this.branchName,
    this.principalRepayMethodCode,
    this.cBCKScore,
    this.handleFee,
    this.feeTypeCode,
    this.loanApplicationTypeCode,
    this.applyInterestRate,
    this.paymentCycleMonthly,
    this.checkCollectionAmount,
    //
  });

  factory ListApproval.fromJson(Map<String, dynamic> json) {
    return ListApproval(
      applicationAmount: json['applicationAmount'] as dynamic,
      customerNo: json['customerNo'] as dynamic,
      customerName: json['customerName'] as dynamic,
      applicationDate: json['applicationDate'] as dynamic,
      loanApprovalApplicationNo: json['loanApprovalApplicationNo'] as dynamic,
      creditRiskRatingGrade: json['creditRiskRatingGrade'] as dynamic,
      currencyCode: json['currencyCode'] as dynamic,
//
      cbcFee: json['cbcFee'] as dynamic,
      loanTermTypeCode: json['loanTermTypeCode'] as dynamic,
      firstInterestPaymentDate: json['firstInterestPaymentDate'] as dynamic,
      collateralLoanRatio: json['collateralLoanRatio'] as dynamic,
      collateralLoanYn: json['collateralLoanYn'] as dynamic,
      loanExpiryDate: json['loanExpiryDate'] as dynamic,
      loanApplicationKindCode: json['loanApplicationKindCode'] as dynamic,
      fireInsuranceExpiryDate: json['fireInsuranceExpiryDate'] as dynamic,
      productName: json['productName'] as dynamic,
      houseCorporationTypeCode: json['houseCorporationTypeCode'] as dynamic,
      applicationBranchCode: json['applicationBranchCode'] as dynamic,
      cBCReferenceNo: json['cBCReferenceNo'] as dynamic,
      overdueGracePeriodDays: json['overdueGracePeriodDays'] as dynamic,
      loanFundPurposeCode: json['loanFundPurposeCode'] as dynamic,
      totalDebtPrincipalInterestAmountRatio:
          json['totalDebtPrincipalInterestAmountRatio'] as dynamic,
      interestExemptionPeriod: json['interestExemptionPeriod'] as dynamic,
      loanApplicationProgressStatusCode:
          json['loanApplicationProgressStatusCode'] as dynamic,
      creditRiskRatingScore: json['creditRiskRatingScore'] as dynamic,
      loanFundPurposeAmount: json['loanFundPurposeAmount'] as dynamic,
      unUseFee: json['unUseFee'] as dynamic,
      loanAuthorityCode: json['loanAuthorityCode'] as dynamic,
      loanPeriodMonthlyCount: json['loanPeriodMonthlyCount'] as dynamic,
      loanFundPurposeAmount3: json['loanFundPurposeAmount3'] as dynamic,
      monthRepayAmount: json['applicationAmount'] as dynamic,
      loanFundPurposeAmount2: json['loanFundPurposeAmount2'] as dynamic,
      overdueYN: json['overdueYN'] as dynamic,
      remark4: json['remark4'] as dynamic,
      loanGracePeriodMonths: json['loanGracePeriodMonths'] as dynamic,
      creditBureauCombodiaGrade: json['creditBureauCombodiaGrade'] as dynamic,
      fundSourceCode: json['fundSourceCode'] as dynamic,
      calculationCollateralLoanRatio:
          json['calculationCollateralLoanRatio'] as dynamic,
      remark2: json['remark2'] as dynamic,
      creditBureauCombodiaScore: json['creditBureauCombodiaScore'] as dynamic,
      loanProductCode: json['loanProductCode'] as dynamic,
      loanCounselNo: json['loanCounselNo'] as dynamic,
      statusCD: json['statusCD'] as dynamic,
      fireInsuranceAmount: json['fireInsuranceAmount'] as dynamic,
      applicationHandlerEmployeeNo:
          json['applicationHandlerEmployeeNo'] as dynamic,
      linkTransactionYN: json['linkTransactionYN'] as dynamic,
      loanFundPurposeCode3: json['loanFundPurposeCode3'] as dynamic,
      loanHopeDate: json['loanHopeDate'] as dynamic,
      loanFundPurposeCode2: json['loanFundPurposeCode2'] as dynamic,
      employeeName1: json['employeeName1'] as dynamic,
      frequencyTypeCode: json['frequencyTypeCode'] as dynamic,
      grid01Count: json['grid01Count'] as dynamic,
      fireInsuranceTargetYN: json['fireInsuranceTargetYN'] as dynamic,
      branchName: json['branchName'] as dynamic,
      principalRepayMethodCode: json['principalRepayMethodCode'] as dynamic,
      cBCKScore: json['cBCKScore'] as dynamic,
      handleFee: json['handleFee'] as dynamic,
      feeTypeCode: json['feeTypeCode'] as dynamic,
      loanApplicationTypeCode: json['loanApplicationTypeCode'] as dynamic,
      applyInterestRate: json['applyInterestRate'] as dynamic,
      paymentCycleMonthly: json['paymentCycleMonthly'] as dynamic,
      checkCollectionAmount: json['checkCollectionAmount'] as dynamic,
//
    );
  }
}
