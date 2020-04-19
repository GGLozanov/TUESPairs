import React from 'react';
import { Link } from 'react-router-dom';

import SignOutButton from '../SignOut/signout.jsx';
import * as ROUTES from '../../../constants/routes';
import { AuthUserContext } from '../../Authentication';
import PeopleIcon from '@material-ui/icons/People';
import ChatIcon from '@material-ui/icons/Chat';
import AssignmentIndIcon from '@material-ui/icons/AssignmentInd';
import 'bootstrap/dist/css/bootstrap.min.css';
import './style.scss';
import { Navbar, Nav } from 'react-bootstrap';

const Navigation = () => (
      <AuthUserContext.Consumer>
        {authUser => {
          if(!authUser) {
            return <NavigationNotLogged />
          } else if(authUser.photoURL) {
            return <NavigationLogged />
          } else {
            return <NavigationNotLogged />
          }
        }
          
        }
      </AuthUserContext.Consumer>
);

const NavigationLogged = () => (
  <Navbar collapseOnSelect expand="lg" bg="dark">
  <Navbar.Brand href="/home">
    <img src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/TP-logo-2.png?alt=media&token=8378bc71-6fc6-4373-ac38-5f86a8b3295b" alt="TUESPairs logo"></img>
  </Navbar.Brand>
  <Navbar.Toggle aria-controls="responsive-navbar-nav" />
    <Navbar.Collapse id="responsive-navbar-nav">
      <Nav variant="tabs" defaultActiveKey="list-2">
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
              <PeopleIcon fontSize="default"></PeopleIcon>
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
      <img src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/TP-logo-2.png?alt=media&token=8378bc71-6fc6-4373-ac38-5f86a8b3295b" alt="TUESPairs logo"></img>
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