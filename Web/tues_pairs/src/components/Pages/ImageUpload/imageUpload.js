import React, {Component} from 'react';
import { withAuthorization } from '../../Authentication';

import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';


const ImageUploadPage = () => (
    <div>
        <h1>Upload your profile image</h1>
        <ImageUploadForm />
    </div>
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
            console.log(error);
        }, 
        () => {
            // complete function ....
            this.props.firebase.storage.ref('/').child(image.name).getDownloadURL().then(url => {
                console.log(url);
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
                        this.props.history.push(ROUTES.ACCOUNT);
                    }
                })
                .catch(error => {
                    console.log(error);
                });
            })
        });
    }
    
    render() {
        const style = {
        height: '100vh',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center'
        };

        return (
        <div style={style}>
        <progress value={this.state.progress} max="100"/>
        <br/>
            <input type="file" onChange={this.handleChange}/>
            <button onClick={this.handleUpload}>Upload</button>
            <br/>
            <img src={this.photoURL || 'http://via.placeholder.com/400x300'} alt="Uploaded images" height="300" width="400"/>
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