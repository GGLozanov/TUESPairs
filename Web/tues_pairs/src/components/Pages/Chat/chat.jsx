import React from 'react';
import { withAuthorization } from '../../Authentication';

const ChatPage = () => (
    <div>
        <h1>Chat Page</h1>
        <p>The chat page is accsessible when user is successfully matched.</p>
    </div>
);

const condition = authUser => !!authUser;

export default withAuthorization(condition)(ChatPage);