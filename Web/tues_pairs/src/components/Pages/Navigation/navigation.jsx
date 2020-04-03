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

const Navigation = ({ authUser }) => (
      <AuthUserContext.Consumer>
        {authUser =>
          authUser ? <NavigationLogged /> : <NavigationNotLogged />
        }
      </AuthUserContext.Consumer>
);

const NavigationLogged = () => (
  <Navbar collapseOnSelect expand="lg" bg="dark">
  <Navbar.Brand>
    <img src="https://bonitaselfdefense.com/wp-content/uploads/2017/04/default-image.jpg" alt="TUESPairs logo"></img>
  </Navbar.Brand>
  <Navbar.Toggle aria-controls="responsive-navbar-nav" />
    <Navbar.Collapse id="responsive-navbar-nav">
      <Nav variant="tabs" defaultActiveKey="list-2">
        <Nav.Item>
          <Nav.Link eventKey="list-3">
            <Link to={ROUTES.CHAT}>
              <ChatIcon fontSize="medium"></ChatIcon>
            </Link>
          </Nav.Link>
        </Nav.Item>
        <Nav.Item>
          <Nav.Link eventKey="list-2">
            <Link to={ROUTES.HOME}>
              <PeopleIcon fontSize="medium"></PeopleIcon>
            </Link>
          </Nav.Link>
        </Nav.Item>
        <Nav.Item>
          <Nav.Link eventKey="list-1">
            <Link to={ROUTES.ACCOUNT}>
              <AssignmentIndIcon fontSize="medium"></AssignmentIndIcon>
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
    <Navbar.Brand>
      <img src="https://bonitaselfdefense.com/wp-content/uploads/2017/04/default-image.jpg" alt="TUESPairs logo"></img>
    </Navbar.Brand>
  </Navbar>
)

export default Navigation;