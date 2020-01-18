class CustomQBUser {
  List<Users> users;
  int perPage;
  int total;
  int page;

  CustomQBUser({this.users, this.perPage, this.total, this.page});

  CustomQBUser.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    perPage = json['perPage'];
    total = json['total'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['perPage'] = this.perPage;
    data['total'] = this.total;
    data['page'] = this.page;
    return data;
  }
}

class Users {
  int id;
  String login;
  String lastRequestAt;
  String fullName;

  Users({this.id, this.login, this.lastRequestAt, this.fullName});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    lastRequestAt = json['lastRequestAt'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['lastRequestAt'] = this.lastRequestAt;
    data['fullName'] = this.fullName;
    return data;
  }
}
