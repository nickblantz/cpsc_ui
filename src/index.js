import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

var storedUser = localStorage.getItem('authenticated-user');
var user = storedUser ? JSON.parse(storedUser) : null;
var root = document.getElementById('root');

var app = Elm.Main.init({
  flags: user,
  node: root
});

app.ports.storeUser.subscribe(function(user) {
  if (user.length > 0) {
      var postsJson = JSON.stringify(user);
      localStorage.setItem('authenticated-user', postsJson);
      console.log("Saved state: ", postsJson);
  } else {
      console.log("No data given");
  }
});

app.ports.clearUser.subscribe(function(_x) {
  localStorage.clear();
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
