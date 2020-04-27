import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';


var app = Elm.Main.init({
  node: document.getElementById('root')
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

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
