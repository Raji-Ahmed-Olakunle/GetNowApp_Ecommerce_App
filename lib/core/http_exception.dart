class httpException implements Exception{
  String Message;
  httpException(this.Message);
  @override
  String toString() {
    // TODO: implement toString
    return Message;
  }
}