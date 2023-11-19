class SignUpModel {
  SignUpModel({this.name, this.email, this.password});
  String? name;
  String? email;
  String? password;
  Map<String, dynamic> toJson() =>
      {"name": name, "email": email, "password": password};
}
