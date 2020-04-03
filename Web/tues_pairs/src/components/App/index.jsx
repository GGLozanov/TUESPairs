import React from 'react';
import { BrowserRouter as Router, Route, } from 'react-router-dom';
import './app.scss';

import Navigation from '../Pages/Navigation/navigation';
import ChatPage from '../Pages/Chat/chat';
import PasswordForgetPage from '../Pages/PasswordForget';
import HomePage, { AlreadyMatchedPage } from '../Pages/Home/home';
import AccountPage from '../Pages/Account/account';
import ImageUploadPage from '../Pages/ImageUpload/imageUpload';

import * as ROUTES from '../../constants/routes.jsx';
import { withAuthentication } from '../Authentication';
import ChangeHandler from '../Pages/Authentication/changeHandler';
import StudentInfo from '../Pages/Account/edit_personal_info';

const App = () => (
    <Router>
        <Navigation />
        <div className="main">
            <Route path={ROUTES.SIGN} component={ChangeHandler} />

            <Route exact path={ROUTES.CHAT} component={ChatPage} />
            <Route path={ROUTES.PASSWORD_FORGET} component={PasswordForgetPage} />
            <Route path={ROUTES.HOME} component={HomePage} />
            <Route path={ROUTES.ACCOUNT} component={AccountPage} />
            <Route path={ROUTES.IMAGE_UPLOAD} component={ImageUploadPage} />
            <Route path={ROUTES.ALREADY_MATCHED_PAGE} component={AlreadyMatchedPage} />
            <Route path={ROUTES.EDIT_PERSONAL_INFO} component={StudentInfo} />
        </div>
    </Router>
);

export default withAuthentication(App);