import React from 'react';
import { withAuthorization } from '../../Authentication';

const HomePage = () => (
  <div>
    <h1>Home Page</h1>
    <p>Currently working on it!</p>
  </div>
);

const condition = authUser => !!authUser;

export default withAuthorization(condition)(HomePage);