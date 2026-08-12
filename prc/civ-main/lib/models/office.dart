class GovernmentOffice {
  final String id;
  final String name;
  final String abbreviation;
  final List<String> handles;
  final String contactNumber;
  final String? email;
  final String? address;

  const GovernmentOffice({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.handles,
    required this.contactNumber,
    this.email,
    this.address,
  });
}
