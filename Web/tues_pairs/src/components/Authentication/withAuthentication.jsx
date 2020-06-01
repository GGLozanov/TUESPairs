import React from 'react';

import AuthUserContext from './context';
import { withFirebase } from '../Firebase';
import log from '../../constants/logger.jsx';

const withAuthentication = Component => {
    class WithAuthentication extends React.Component {
        constructor(props) {
            super(props);

            this.state = {
                authUser: null,
            };
        }

        componentDidMount() {
            this.listener = this.props.firebase.auth.onAuthStateChanged(
                authUser => {
                    if(authUser) {
                        log.info("Successfully authenticated user a new authUser!");
                        this.props.firebase.user(authUser.uid).get()
                        .then(snapshot => {
                            authUser = this.props.firebase.getUserFromSnapshot(snapshot);
                            log.info("Successfully garnered current user information!");

                            this.setState({ authUser });
                        }).then(() => {
                            this.props.firebase.messaging.requestPermission().then(() => {
                                this.props.firebase.messaging.getToken().then(token => {
                                    if(authUser.deviceTokens && !authUser.deviceTokens.includes(token)) {
                                        authUser.deviceTokens.push(token);
                                    }

                                    this.props.firebase.db.collection("users").doc(authUser.uid).set({
                                        deviceTokens: authUser.deviceTokens
                                    }, { merge: true });

                                    this.setState({ authUser });
                                }).catch(error => {
                                    log.error(error);
                                });
                            })
                        }).catch(error => {
                            log.error(error);
                        })
                    } else {
                        log.info("User not authenticated (authUser). Going to Authenticate!");
                        this.setState({ authUser: null })
                    }
                }
            );
        }

        componentWillUnmount() {
            this.listener();
        }

        render() {
            return (
                <AuthUserContext.Provider value={this.state.authUser}>
                    <Component { ...this.props} />
                </AuthUserContext.Provider>
            );
        }
    }

    return withFirebase(WithAuthentication);
};

export default withAuthentication;