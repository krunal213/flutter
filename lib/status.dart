class StatusResponse<T> {
  Status status;
  T data;
  String message;

  StatusResponse.loading() : status = Status.LOADING;
  StatusResponse.completed(this.data) : status = Status.COMPLETED;
  StatusResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }