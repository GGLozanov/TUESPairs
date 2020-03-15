import React from 'react';
import {
  BrowserRouter as Router,
  Route,
} from 'react-router-dom';
import Navigation from '../Navigation';
//import LandingPage from '../Landing';
import SignUpPage from '../SignUp';
import SignInPage from '../SignIn';
//import PasswordForgetPage from '../PasswordForget';
//import HomePage from '../Home';
//import AccountPage from '../Account';
//import AdminPage from '../Admin';
import * as ROUTES from '../../constants/routes';
const App = () => (
  <Router>
    <div>
      <Navigation />
      <hr />
      <Route path={ROUTES.SIGN_UP} component={SignUpPage} />
      <Route path={ROUTES.SIGN_IN} component={SignInPage} />
    </div>
  </Router>
);
export default App;