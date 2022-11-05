class ClientModel{
  String? c_id;
  String? c_fullname;
  String? c_cnic;
  String? c_email;
  String? c_password;
  String? c_profilepic;
  String? c_address;


  ClientModel({this.c_id, this.c_fullname, this.c_cnic, this.c_email, this.c_password, this.c_profilepic,this.c_address});

  factory ClientModel.fromMap(map){
    return ClientModel(
      c_id: map['c_ID'],
      c_fullname: map['c_FullName'],
      c_cnic: map['c_CNIC'],
      c_email: map['c_Email'],
      c_password: map['c_Password'],
      c_profilepic: map['c_ProfilePic'],
      c_address: map['c_Address'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'c_ID' : c_id,
      'c_FullName' : c_fullname,
      'c_CNIC' : c_cnic,
      'c_Email' : c_email,
      'c_Password' : c_password,
      'c_ProfilePic' :  c_profilepic,
      'c_Address' : c_address
    };
  }

}