import React, {Component} from 'react';
import { withAuthorization } from '../../Authentication';

import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { Button, ProgressBar, Form, Col, Image } from 'react-bootstrap';
import './style.scss';

const ImageUploadPage = () => (
    <ImageUploadForm />
);

class ImageUploadBase extends Component {
    constructor(props) {
        super(props);
        

        this.state = {
            image: null,
            progress: 0,
            url: this.props.authUser.photoURL,
            currentUser: this.props.authUser,
        }
        
        this.handleChange = this
            .handleChange
            .bind(this);
            this.handleUpload = this.handleUpload.bind(this);

    }

    componentDidMount() {
        let currentUser = this.state.currentUser;

        this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            currentUser = this.props.firebase.currentUser(snapshot);

            this.setState({ currentUser, url: currentUser.photoURL });
        }).catch(error => {
            console.error(error);
        })
    }

    handleClearImage = () => {
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            photoURL: null,
        }, {merge: true})
        .then(() => {
            this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);
        })
        .catch(error => {
            console.error(error);
        });
    }

    handleChange = e => {
        if (e.target.files[0]) {
            const image = e.target.files[0];
            this.setState(() => ({image}));
        }
    }

    handleUpload = () => {
        const {image} = this.state;
        const uploadTask = this.props.firebase.storage.ref(`/${image.name}`).put(image);
        const currentUser = this.state.currentUser;

        uploadTask.on('state_changed', 
        (snapshot) => {
            // progrss function ....
            const progress = Math.round((snapshot.bytesTransferred / snapshot.totalBytes) * 100);
            this.setState({progress});
        }, 
        (error) => {
            // error function ....
            
            console.error(error);
        }, 
        () => {
            // complete function ....
            this.props.firebase.storage.ref('/').child(image.name).getDownloadURL().then(url => {
                this.setState({ url });
                this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                    photoURL: url,
                }, {merge: true})
                .then(() => {
                    this.props.history.push(ROUTES.HOME);
                })
                .catch(error => {
                    console.error(error);
                });
            })
        });
    }
    
    render() {
        const photoURL = this.state.url;

        const isDisabled = this.state.image ? false : true;

        const hasImage = photoURL ? true : false;

        return (
        <div className="image-upload">
            <div className="hedaer">
                <h1>Upload image</h1>
            </div>
            <div className="upload-handler">
                <ProgressBar className="progress-bar" now={this.state.progress} label={`${this.state.progress}%`} />
                <Form className="file-input">
                    <Form.File 
                        id="custom-file"
                        label="Custom file input"
                        onChange={this.handleChange}
                        custom
                    />
                </Form>
                <Col xs={14} md={14}>
                    {hasImage && <Image src={photoURL} rounded/>}
                    {!hasImage && <Image src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png" rounded/>}
                </Col>
                <Button disabled={isDisabled} onClick={this.handleUpload}>Upload</Button>
                <Button disabled={!hasImage} onClick={this.handleClearImage}>Clear Image</Button>
                
            </div>
        </div>
        )
    }
}

const condition = authUser => !!authUser;

const ImageUploadForm = compose (
    withRouter,
    withCurrentUser,
    withAuthorization(condition)
)(ImageUploadBase);

export default ImageUploadPage;

export { ImageUploadForm };