
class UserSchema {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String publicKey;
  String privateKeyEncrypted;

  UserSchema({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.publicKey,
    required this.privateKeyEncrypted,
  });

  factory UserSchema.fromJson(Map<String, dynamic> json) {
    return UserSchema(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      publicKey: json['publicKey'],
      privateKeyEncrypted: json['privateKeyEncrypted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'publicKey': publicKey,
      'privateKeyEncrypted': privateKeyEncrypted,
    };
  }
}