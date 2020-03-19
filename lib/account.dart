class Account {
  String username, password, type, picture;

  Account(this.username, this.password, this.type, this.picture);

  factory Account.fromJson(dynamic json) {
    return Account(
      json['name'] as String,
      json['password'] as String,
      json['type'] as String,
      json['picture'] as String,
    );
  }
}