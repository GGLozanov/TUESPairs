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
            url: ''
        }
        
        this.handleChange = this
            .handleChange
            .bind(this);
            this.handleUpload = this.handleUpload.bind(this);

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
        let hasImage = null;
        const currentUser = this.props.authUser;

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
                if(currentUser.photoURL === null) {
                    hasImage = false;
                } else {
                    hasImage = true;
                }
                this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                    photoURL: url,
                }, {merge: true})
                .then(() => {
                    if(hasImage === false) {
                        this.props.history.push(ROUTES.HOME);
                    } else {
                        this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);
                    }
                })
                .catch(error => {
                    console.error(error);
                });
            })
        });
    }
    
    render() {

        const isDisabled = this.state.image ? false : true;

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
                    <Image src={this.props.authUser.photoURL} rounded/>
                </Col>
                <Button disabled={isDisabled} onClick={this.handleUpload}>Upload</Button>
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