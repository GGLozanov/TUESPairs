import React from 'react';
import { Link } from 'react-router-dom';

import SignOutButton from '../SignOut/signout';
import * as ROUTES from '../../../constants/routes';
import { AuthUserContext } from '../../Authentication';

const Navigation = ({ authUser }) => (
  <div>
    <AuthUserContext.Consumer>
      {authUser =>
        authUser ? <NavigationLogged /> : null
      }
    </AuthUserContext.Consumer>
  </div>
);

const NavigationLogged = () => (
  <ul>
      <li>
        <Link to={ROUTES.HOME}>Home</Link>
      </li>
      <li>
        <Link to={ROUTES.ACCOUNT}>Account</Link>
      </li>
      <li>
        <SignOutButton />
      </li>
  </ul>
);

export default Navigation;