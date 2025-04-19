class Company {
  String name;
  String address;
  String phone;
  String? email;
  String? fssai;

  Company({required this.name, required this.address, required this.phone, this.fssai, this.email});

  Company.fromJson(Map<String, dynamic> json)
    : name = json['name'] ?? '',
      address = json['address'] ?? '',
      phone = json['phone'] ?? '',
      email = json['email'] ?? '',
      fssai = json['fssai'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['fssai'] = fssai;

    return data;
  }
}
