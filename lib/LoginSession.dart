
class LoginSession {
	static final LoginSession _loginSession = LoginSession._internal();
	
	factory LoginSession() => _loginSession;
	
	LoginSession._internal();
	
	static LoginSession get shared => _loginSession;
	var loggedIn;
	var username;
	var password;
}