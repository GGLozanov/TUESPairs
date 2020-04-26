import React from 'react';
import { Link } from 'react-router-dom';

import SignOutButton from '../SignOut/signout.jsx';
import * as ROUTES from '../../../constants/routes';
import { AuthUserContext } from '../../Authentication';
import HomeIcon from '@material-ui/icons/Home';
import ChatIcon from '@material-ui/icons/Chat';
import AssignmentIndIcon from '@material-ui/icons/AssignmentInd';
import 'bootstrap/dist/css/bootstrap.min.css';
import './style.scss';
import { Navbar, Nav } from 'react-bootstrap';

const Navigation = () => (
      <AuthUserContext.Consumer>
        {authUser => 
          authUser ? <NavigationLogged /> : <NavigationNotLogged />
        }
      </AuthUserContext.Consumer>
);

const NavigationLogged = () => (
  <Navbar collapseOnSelect expand="lg" bg="dark">
  <Navbar.Brand href="/home">
    <img src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/Logo_Text.png?alt=media&token=d787193b-09ef-468a-b6c8-034c1497e8c8" alt="TUESPairs logo"></img>
  </Navbar.Brand>
  <Navbar.Toggle aria-controls="responsive-navbar-nav" />
    <Navbar.Collapse id="responsive-navbar-nav">
      <Nav variant="tabs">
        <Nav.Item>
          <Nav.Link eventKey="list-3">
            <Link to={ROUTES.CHAT}>
              <ChatIcon fontSize="default"></ChatIcon>
            </Link>
          </Nav.Link>
        </Nav.Item>
        <Nav.Item>
          <Nav.Link eventKey="list-2">
            <Link to={ROUTES.HOME}>
              <HomeIcon fontSize="default"></HomeIcon>
            </Link>
            </Nav.Link>
        </Nav.Item>
        <Nav.Item>
          <Nav.Link eventKey="list1">
            <Link to={ROUTES.ACCOUNT}>
              <AssignmentIndIcon fontSize="default"></AssignmentIndIcon>
            </Link>
          </Nav.Link>
        </Nav.Item>
      </Nav>
    <SignOutButton />
    </Navbar.Collapse>
  </Navbar>
);

const NavigationNotLogged = () => (
  <Navbar collapseOnSelect expand="lg" bg="dark">
    <Navbar.Brand href="/sign">
      <img src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/Logo_Text.png?alt=media&token=d787193b-09ef-468a-b6c8-034c1497e8c8" alt="TUESPairs logo"></img>
    </Navbar.Brand>
  </Navbar>
)

const Footer = () => (
  <footer className="site-footer">
        <hr />
    <ul>
        <li>Copyright © 2020 all rights reserved</li>
    </ul>
  </footer>
)

export { Footer };

export default Navigation;