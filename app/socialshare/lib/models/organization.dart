class Organization {
  final String id;
  final String name;
  final String description;
  final String linkedinUrl;
  final String twitterUrl;
  final String? websiteUrl;
  final String? logoUrl;
  final String location;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.linkedinUrl,
    required this.twitterUrl,
    this.websiteUrl,
    this.logoUrl,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'linkedinUrl': linkedinUrl,
      'twitterUrl': twitterUrl,
      'websiteUrl': websiteUrl,
      'logoUrl': logoUrl,
      'location': location,
    };
  }

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      linkedinUrl: json['linkedinUrl'],
      twitterUrl: json['twitterUrl'],
      websiteUrl: json['websiteUrl'],
      logoUrl: json['logoUrl'],
      location: json['location'],
    );
  }
}
