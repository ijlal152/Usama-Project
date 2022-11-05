class LawyerModel{
  String? l_id;
  String? l_fullname;
  String? l_cnic;
  String? l_email;
  String? l_password;
  String? l_phoneno;
  String? l_profilepic;
  String? l_address;

  LawyerModel({this.l_id, this.l_fullname, this.l_cnic, this.l_email, this.l_password, this.l_phoneno, this.l_profilepic,this.l_address});

  factory LawyerModel.fromMap(map){
    return LawyerModel(
      l_id: map['l_ID'],
      l_fullname: map['l_FullName'],
      l_cnic: map['l_CNIC'],
      l_email: map['l_Email'],
      l_password: map['l_Password'],
      l_phoneno: map['l_phoneno'],
      l_profilepic: map['l_ProfilePic'],
      l_address: map['l_Address'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'l_ID' : l_id,
      'l_FullName' : l_fullname,
      'l_CNIC' : l_cnic,
      'l_Email' : l_email,
      'l_Password' : l_password,
      'l_phoneno' : l_phoneno,
      'l_ProfilePic' : l_profilepic,
      'l_Address' : l_address
    };
  }

}