class Company {
  String name;
  String address;
  String phone;
  String fssai;

  Company({this.name, this.address, this.phone, this.fssai});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    fssai = json['fssai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['fssai'] = this.fssai;

    return data;
  }
}
