import React from 'react';
import { Link } from 'react-router-dom';

import SignOutButton from '../SignOut/signout.jsx';
import * as ROUTES from '../../../constants/routes';
import { AuthUserContext } from '../../Authentication';
import './style.scss';

const Navigation = ({ authUser }) => (
  <div className="navbar">
      <AuthUserContext.Consumer>
        {authUser =>
          authUser ? <NavigationLogged /> : <NavigationNotLogged />
        }
      </AuthUserContext.Consumer>
  </div>
);

const NavigationLogged = () => (
  <div className="links">
        <img src="https://bonitaselfdefense.com/wp-content/uploads/2017/04/default-image.jpg" alt="TUESPairs logo"></img>
        <Link to={ROUTES.HOME}>Home</Link>
        <Link to={ROUTES.ACCOUNT}>Account</Link>
        <SignOutButton />
  </div>
);

const NavigationNotLogged = () => (
  <div className="logo">
    <img src="https://bonitaselfdefense.com/wp-content/uploads/2017/04/default-image.jpg" alt="TUESPairs logo"></img>
  </div>
)

export default Navigation;