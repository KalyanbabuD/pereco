class LeadProfile {
  final int id;
  final String name;
  final String company;
  final String description;
  final String zip;
  final String city;
  final String state;
  final String address;
  final String email;
  final String website;
  final String phonenumber;
  final String leadValue;
  final String sourceName;
  final String statusName;
  final String assignedTo;
  final String dateAdded;

  LeadProfile({
    required this.id,
    required this.name,
    required this.company,
    required this.description,
    required this.zip,
    required this.city,
    required this.state,
    required this.address,
    required this.email,
    required this.website,
    required this.phonenumber,
    required this.leadValue,
    required this.sourceName,
    required this.statusName,
    required this.assignedTo,
    required this.dateAdded,
  });

  factory LeadProfile.fromJson(Map<String, dynamic> json) {
    return LeadProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      description: json['description'] ?? '',
      zip: json['zip'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      leadValue: json['lead_value']?.toString() ?? '0.00',
      sourceName: json['SourceName'] ?? '',
      statusName: json['StatusName'] ?? '',
      assignedTo: json['AssignedTo'] ?? '',
      dateAdded: json['dateadded'] ?? '',
    );
  }
}

class Proposal {
  final int id;
  final String subject;
  final String total;
  final String proposalTo;
  final String date;
  final String addedByName;
  final int status;

  Proposal({
    required this.id,
    required this.subject,
    required this.total,
    required this.proposalTo,
    required this.date,
    required this.addedByName,
    required this.status,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? '',
      total: json['total']?.toString() ?? '0.00',
      proposalTo: json['proposal_to'] ?? '',
      date: json['open_till'] ?? '', // Using open_till for date
      addedByName: json['AddedByName'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}

class FollowUp {
  final int id;
  final String description;
  final String date;
  final String firstName;
  final String lastName;
  final int? staff;

  FollowUp({
    required this.id,
    required this.description,
    required this.date,
    required this.firstName,
    required this.lastName,
    this.staff,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      staff: json['staff'] != null ? int.tryParse(json['staff'].toString()) : null,
    );
  }
}

class Note {
  final int id;
  final String description;
  final String addedByName;
  final String dateAdded;

  Note({
    required this.id,
    required this.description,
    required this.addedByName,
    required this.dateAdded,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      addedByName: json['added_by_name'] ?? '',
      dateAdded: json['dateadded'] ?? '',
    );
  }
}
