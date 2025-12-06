class Company {
  String name;
  String address;
  String phone;
  String? email;
  String? fssai;
  // dimensions in mm
  int width;
  int height;
  int columns;
  int columnGap;
  int rowGap;
  bool reverseDirection;
  bool hideCompanyDetails;

  Company({
    required this.name,
    required this.address,
    required this.phone,
    this.fssai,
    this.email,
    this.width = 50,
    this.height = 30,
    this.columns = 2,
    this.columnGap = 3,
    this.rowGap = 3,
    this.reverseDirection = false,
    this.hideCompanyDetails = false,
  });

  Company.fromJson(Map<String, dynamic> json)
    : name = json['name'] ?? '',
      address = json['address'] ?? '',
      phone = json['phone'] ?? '',
      email = json['email'] ?? '',
      fssai = json['fssai'] ?? '',
      width = json['width'] is int ? json['width'] : int.tryParse(json['width'] ?? '50') ?? 50,
      height = json['height'] is int ? json['height'] : int.tryParse(json['height'] ?? '30') ?? 30,
      columns = json['columns'] is int ? json['columns'] : int.tryParse(json['columns'] ?? '2') ?? 2,
      columnGap = json['columnGap'] is int ? json['columnGap'] : int.tryParse(json['columnGap'] ?? '3') ?? 3,
      rowGap = json['rowGap'] is int ? json['rowGap'] : int.tryParse(json['rowGap'] ?? '3') ?? 3,
      reverseDirection = json['reverseDirection'] ?? false,
      hideCompanyDetails = json['hideCompanyDetails'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['fssai'] = fssai;
    data['width'] = width;
    data['height'] = height;
    data['columns'] = columns;
    data['columnGap'] = columnGap;
    data['rowGap'] = rowGap;
    data['reverseDirection'] = reverseDirection;
    data['hideCompanyDetails'] = hideCompanyDetails;

    return data;
  }
}
