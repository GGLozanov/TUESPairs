import React from 'react';
import { BrowserRouter as Router, Route, } from 'react-router-dom';
import './app.scss';

import Navigation from '../Pages/Navigation/navigation';
import LandingPage from '../Pages/Landing/landing';
import PasswordForgetPage from '../Pages/PasswordForget/passwordforget';
import HomePage, { AlreadyMatchedPage } from '../Pages/Home/home';
import AccountPage from '../Pages/Account/account';
import ImageUploadPage from '../Pages/ImageUpload/imageUpload';

import * as ROUTES from '../../constants/routes';
import { withAuthentication } from '../Authentication';
import ChangeHandler from '../Pages/Authentication/changeHandler';

const App = () => (
    <Router>
        <div className="main">

            <Route path={ROUTES.SIGN} component={ChangeHandler} />
            <Navigation />

            <Route exact path={ROUTES.LANDING} component={LandingPage} />
            <Route path={ROUTES.PASSWORD_FORGET} component={PasswordForgetPage} />
            <Route path={ROUTES.HOME} component={HomePage} />
            <Route path={ROUTES.ACCOUNT} component={AccountPage} />
            <Route path={ROUTES.IMAGE_UPLOAD} component={ImageUploadPage} />
            <Route path={ROUTES.ALREADY_MATCHED_PAGE} component={AlreadyMatchedPage} />
        </div>
    </Router>
);

export default withAuthentication(App);