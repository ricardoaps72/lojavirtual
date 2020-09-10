bool emailValid(String email){
  final  RegExp regex =  RegExp(
     r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9] {1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[A-zA-Z]{2,}))$");
  return regex.hasMatch(email);
}