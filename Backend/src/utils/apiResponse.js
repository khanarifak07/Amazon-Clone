class ApiResponse {
  constructor(statusCode, data, message = "success") {
    this.data = data;
    this.message = message;
    this.statusCode = statusCode;
    this.success = statusCode < 400;
  }
}

export { ApiResponse };

//100 - 199 (Informational responses)
//200 - 299 (success responses)
//300 - 399 (redirecion messages)
//400 - 499 (client side error responses)
//500 - 599 (server side error responses)
