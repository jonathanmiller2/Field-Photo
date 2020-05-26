///This is Flutter's version of a singleton. There is only ever one LoginSession, and it can be accessed from everywhere.
///The LoginSession is used in several places to determine whether the user is currently logged in, and the username/password they are logged in with.
///The username and password are set upon login.
class LoginSession {
	static final LoginSession _loginSession = LoginSession._internal();
	
	factory LoginSession() => _loginSession;
	
	LoginSession._internal();
	
	static LoginSession get shared => _loginSession;
	var loggedIn;
	var username;
	var password;
}