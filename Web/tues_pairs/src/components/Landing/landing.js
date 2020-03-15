import React from 'react';

import { withAuthorization } from '../Session';

const LandingPage = () => (
    <div>
        <h1>Landing Page</h1>
        <p>The landing page is accessible by every signed in user.</p>
    </div>
);

export default LandingPage;