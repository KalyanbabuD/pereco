class OrgSettingsResponse {
  bool? status;
  String? message;
  OrgSettingsData? resultData;

  OrgSettingsResponse({this.status, this.message, this.resultData});

  OrgSettingsResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    resultData = json['ResultData'] != null
        ? OrgSettingsData.fromJson(json['ResultData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (resultData != null) {
      data['ResultData'] = resultData!.toJson();
    }
    return data;
  }
}

class OrgSettingsData {
  String? companyname;
  String? defaultTimezone;
  String? dateformat;
  String? invoiceCompanyName;
  String? invoiceCompanyAddress;
  String? invoiceCompanyCity;
  String? invoiceCompanyCountryCode;
  String? invoiceCompanyPostalCode;
  String? invoiceCompanyPhonenumber;
  String? predefinedTermsInvoice;
  String? predefinedTermsEstimate;
  String? timeFormat;
  String? nextCreditNoteNumber;
  String? nextInvoiceNumber;
  String? nextEstimateNumber;
  String? invoicePrefix;
  String? creditNotePrefix;
  String? proposalNumberPrefix;
  String? estimatePrefix;
  String? gstin;

  OrgSettingsData({
    this.companyname,
    this.defaultTimezone,
    this.dateformat,
    this.invoiceCompanyName,
    this.invoiceCompanyAddress,
    this.invoiceCompanyCity,
    this.invoiceCompanyCountryCode,
    this.invoiceCompanyPostalCode,
    this.invoiceCompanyPhonenumber,
    this.predefinedTermsInvoice,
    this.predefinedTermsEstimate,
    this.timeFormat,
    this.nextCreditNoteNumber,
    this.nextInvoiceNumber,
    this.nextEstimateNumber,
    this.invoicePrefix,
    this.creditNotePrefix,
    this.proposalNumberPrefix,
    this.estimatePrefix,
    this.gstin,
  });

  OrgSettingsData.fromJson(Map<String, dynamic> json) {
    companyname = json['companyname'];
    defaultTimezone = json['default_timezone'];
    dateformat = json['dateformat'];
    invoiceCompanyName = json['invoice_company_name'];
    invoiceCompanyAddress = json['invoice_company_address'];
    invoiceCompanyCity = json['invoice_company_city'];
    invoiceCompanyCountryCode = json['invoice_company_country_code'];
    invoiceCompanyPostalCode = json['invoice_company_postal_code'];
    invoiceCompanyPhonenumber = json['invoice_company_phonenumber'];
    predefinedTermsInvoice = json['predefined_terms_invoice'];
    predefinedTermsEstimate = json['predefined_terms_estimate'];
    timeFormat = json['time_format'];
    nextCreditNoteNumber = json['next_credit_note_number'];
    nextInvoiceNumber = json['next_invoice_number'];
    nextEstimateNumber = json['next_estimate_number'];
    invoicePrefix = json['invoice_prefix'];
    creditNotePrefix = json['credit_note_prefix'];
    proposalNumberPrefix = json['proposal_number_prefix'];
    estimatePrefix = json['estimate_prefix'];
    gstin = json['GSTIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyname'] = companyname;
    data['default_timezone'] = defaultTimezone;
    data['dateformat'] = dateformat;
    data['invoice_company_name'] = invoiceCompanyName;
    data['invoice_company_address'] = invoiceCompanyAddress;
    data['invoice_company_city'] = invoiceCompanyCity;
    data['invoice_company_country_code'] = invoiceCompanyCountryCode;
    data['invoice_company_postal_code'] = invoiceCompanyPostalCode;
    data['invoice_company_phonenumber'] = invoiceCompanyPhonenumber;
    data['predefined_terms_invoice'] = predefinedTermsInvoice;
    data['predefined_terms_estimate'] = predefinedTermsEstimate;
    data['time_format'] = timeFormat;
    data['next_credit_note_number'] = nextCreditNoteNumber;
    data['next_invoice_number'] = nextInvoiceNumber;
    data['next_estimate_number'] = nextEstimateNumber;
    data['invoice_prefix'] = invoicePrefix;
    data['credit_note_prefix'] = creditNotePrefix;
    data['proposal_number_prefix'] = proposalNumberPrefix;
    data['estimate_prefix'] = estimatePrefix;
    data['GSTIN'] = gstin;
    return data;
  }
}
