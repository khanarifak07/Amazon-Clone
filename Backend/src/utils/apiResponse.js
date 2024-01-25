class ApiResponse {
  constructor(statusCode, data, message = "success") {
    this.data = data;
    this.message = message;
    this.statusCode = statusCode;
    this.success = statusCode < 400;
  }
}

export { ApiResponse };

//100 - 199 (Information response)
//200 - 299 (success response)
//300 - 399 (redirecional messages)
//400 - 499 (client error)
//500 - 599 (server side error)
