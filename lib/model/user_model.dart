class UserModel {
  String? uid;
  String? email;
  String? name;
  int? age;

UserModel({this.uid, this.email, this.name, this.age});


factory UserModel.fromMap(map) {
  return UserModel(
    uid: map ['uid'],
    email: map ['email'],
    name: map ['name'],
    age: map ['age'],
  );

}

Map<String, dynamic> toMap(){
  return {
    'uid': uid,
    'email': email,
    'name': name,
    'age': age
  };
}

}