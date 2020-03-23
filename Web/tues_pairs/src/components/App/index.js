import React from 'react';
import { BrowserRouter as Router, Route, } from 'react-router-dom';

import Navigation from '../Navigation/navigation';
import LandingPage from '../Landing/landing';
import SignUpPage from '../SignUp/register';
import SignInPage from '../SignIn/login';
import PasswordForgetPage from '../PasswordForget/passwordforget';
import HomePage from '../Home/home';
import AccountPage from '../Account/account';
import ImageUploadPage from '../ImageUpload/imageUpload';

import * as ROUTES from '../../constants/routes';
import { withAuthentication } from '../Session';

const App = () => (
    <Router>
        <div>
            <Navigation />

            <hr />

            <Route exact path={ROUTES.LANDING} component={LandingPage} />
            <Route path={ROUTES.SIGN_UP} component={SignUpPage} />
            <Route path={ROUTES.SIGN_IN} component={SignInPage} />
            <Route path={ROUTES.PASSWORD_FORGET} component={PasswordForgetPage} />
            <Route path={ROUTES.HOME} component={HomePage} />
            <Route path={ROUTES.ACCOUNT} component={AccountPage} />
            <Route path={ROUTES.IMAGE_UPLOAD} component={ImageUploadPage} />
        </div>
    </Router>
);

export default withAuthentication(App);