 class Model {
  final String? message;

  Model({ this.message});

  factory Model.fromMap(Map<String, dynamic> jsonMap) {
    return Model(
      message: jsonMap["cnt"],
     
    );}
 }
 
 
 