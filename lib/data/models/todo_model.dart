class TodoResponse {
  bool? status;
  int? count;
  List<Todo>? resultData;
  String? message;

  TodoResponse({this.status, this.count, this.resultData, this.message});

  TodoResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    count = json['Count'];
    if (json['ResultData'] != null) {
      resultData = <Todo>[];
      json['ResultData'].forEach((v) {
        resultData!.add(Todo.fromJson(v));
      });
    }
    message = json['Message'];
  }
}

class Todo {
  int? todoid;
  String? description;
  int? staffid;
  String? dateadded;
  int? finished;
  String? datefinished;
  int? itemOrder;
  String? staffName;

  Todo({
    this.todoid,
    this.description,
    this.staffid,
    this.dateadded,
    this.finished,
    this.datefinished,
    this.itemOrder,
    this.staffName,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    todoid = json['todoid'];
    description = json['description'];
    staffid = json['staffid'];
    dateadded = json['dateadded'];
    finished = json['finished'];
    datefinished = json['datefinished'];
    itemOrder = json['item_order'];
    staffName = json['staff_name'];
  }
}
