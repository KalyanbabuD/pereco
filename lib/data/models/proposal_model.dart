class ProposalResponse {
  final bool? status;
  final List<Proposal>? resultData;

  ProposalResponse({this.status, this.resultData});

  factory ProposalResponse.fromJson(Map<String, dynamic> json) {
    return ProposalResponse(
      status: json['Status'] as bool?,
      resultData: (json['ResultData'] as List?)
          ?.map((e) => Proposal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProposalDetailsResponse {
  final Proposal? proposal;
  final List<RelatedItem>? relatedItems;
  final List<ProposalItem>? itemDetails;

  ProposalDetailsResponse({
    this.proposal,
    this.relatedItems,
    this.itemDetails,
  });

  factory ProposalDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProposalDetailsResponse(
      proposal: json['Proposal'] != null
          ? Proposal.fromJson(json['Proposal'] as Map<String, dynamic>)
          : null,
      relatedItems: (json['RelatedItems'] as List?)
          ?.map((e) => RelatedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemDetails: (json['ItemDetails'] as List?)
          ?.map((e) => ProposalItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Proposal {
  final int? id;
  final String? subject;
  final String? content;
  final dynamic addedfrom;
  final String? total;
  final String? subtotal;
  final String? totalTax;
  final String? adjustment;
  final int? relId;
  final String? relType;
  final int? assigned;
  final String? proposalTo;
  final dynamic country;
  final String? zip;
  final String? state;
  final String? city;
  final String? address;
  final String? email;
  final String? phone;
  final String? openTill;
  final int? status;
  final String? addedByName;

  Proposal({
    this.id,
    this.subject,
    this.content,
    this.addedfrom,
    this.total,
    this.subtotal,
    this.totalTax,
    this.adjustment,
    this.relId,
    this.relType,
    this.assigned,
    this.proposalTo,
    this.country,
    this.zip,
    this.state,
    this.city,
    this.address,
    this.email,
    this.phone,
    this.openTill,
    this.status,
    this.addedByName,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'] as int?,
      subject: json['subject'] as String?,
      content: json['content'] as String?,
      addedfrom: json['addedfrom'],
      total: json['total']?.toString(),
      subtotal: json['subtotal']?.toString(),
      totalTax: json['total_tax']?.toString(),
      adjustment: json['adjustment']?.toString(),
      relId: json['rel_id'] as int?,
      relType: json['rel_type'] as String?,
      assigned: json['assigned'] as int?,
      proposalTo: json['proposal_to'] as String?,
      country: json['country'],
      zip: json['zip'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      openTill: json['open_till'] as String?,
      status: json['status'] as int?,
      addedByName: json['AddedByName'] as String?,
    );
  }
}

class RelatedItem {
  final int? itemId;
  final String? commodityName;
  final String? skuCode;

  RelatedItem({
    this.itemId,
    this.commodityName,
    this.skuCode,
  });

  factory RelatedItem.fromJson(Map<String, dynamic> json) {
    return RelatedItem(
      itemId: json['item_id'] as int?,
      commodityName: json['commodity_name'] as String?,
      skuCode: json['sku_code'] as String?,
    );
  }
}

class ProposalItem {
  final int? id;
  final int? relId;
  final String? relType;
  final String? description;
  final String? longDescription;
  final String? qty;
  final String? rate;
  final String? unit;
  final dynamic itemOrder;
  final String? whDeliveredQuantity;

  ProposalItem({
    this.id,
    this.relId,
    this.relType,
    this.description,
    this.longDescription,
    this.qty,
    this.rate,
    this.unit,
    this.itemOrder,
    this.whDeliveredQuantity,
  });

  factory ProposalItem.fromJson(Map<String, dynamic> json) {
    return ProposalItem(
      id: json['id'] as int?,
      relId: json['rel_id'] as int?,
      relType: json['rel_type'] as String?,
      description: json['description'] as String?,
      longDescription: json['long_description'] as String?,
      qty: json['qty']?.toString(),
      rate: json['rate']?.toString(),
      unit: json['unit'] as String?,
      itemOrder: json['item_order'],
      whDeliveredQuantity: json['wh_delivered_quantity']?.toString(),
    );
  }
}
