import React, {Component} from 'react';
import { withAuthorization } from '../../Authentication';

import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { Button, ProgressBar, Form, Col, Image } from 'react-bootstrap';
import HomeIcon from '@material-ui/icons/Home';
import CancelIcon from '@material-ui/icons/Cancel';
import PublishIcon from '@material-ui/icons/Publish';
import AssignmentIndIcon from '@material-ui/icons/AssignmentInd';
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
            show: null,
            upload: false,
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

            this.setState({ currentUser, url: currentUser.photoURL, show: currentUser.photoURL ? true : false });
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
            this.setState({ url: null, show: !this.state.show });
        })
        .catch(error => {
            console.error(error);
        });
    }

    handleChange = e => {
        if (e.target.files[0]) {
            const image = e.target.files[0];
            this.setState({ image, upload: !this.state.upload });
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
                    this.setState({ progress: 0, image: null, upload: !this.state.upload, show: url ? true : false });
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
                <h1>Upload your image</h1>
            </div>
            <div className="upload-handler">
                <ProgressBar className="progress-bar" now={this.state.progress} label={`${this.state.progress}%`} />
                <Form className="file-input">
                    <Form.File 
                        id="custom-file"
                        label="Uploader"
                        onChange={this.handleChange}
                        custom
                    />
                </Form>
                <Col xs={14} md={14}>
                    {hasImage && <Image src={photoURL} rounded/>}
                    {!hasImage && <Image src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png" rounded/>}
                </Col>
                {this.state.upload && <Button disabled={isDisabled} className="upload" onClick={this.handleUpload}>
                    <PublishIcon fontSize="large" />
                </Button>}
                {this.state.show && <Button disabled={!hasImage} className="clear" onClick={this.handleClearImage}>
                    <CancelIcon fontSize="large" />
                </Button>}
            </div>
            <div>
                <Button href="/home">
                    Go to
                    <HomeIcon fontSize="large" />
                </Button>
                <Button href="/edit_personal_info">
                    Go to
                    <AssignmentIndIcon fontSize="large" />
                </Button>
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