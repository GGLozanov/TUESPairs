import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import moment from 'moment';
import { MDBCard, MDBCardBody, MDBRow, MDBCol, MDBListGroup} from "mdbreact";
import "./style.scss";
import { Button, Image, Container } from 'react-bootstrap';
import Aes from 'aes-js';



class Chat extends Component{

    constructor(props){
        super(props);
        this.state = {
            messages: [],
            currentUser: this.props.authUser,
            matchedUser: null,
            content: "",
            key: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        }
    }

    encryptMessage = (message) => {
        
        const textBytes = Aes.utils.utf8.toBytes(message);
        const keyBytes = Aes.utils.utf8.toBytes(this.state.key);
        const aesCtr = new Aes.ModeOfOperation.ctr(keyBytes);
        const encrpytedBytes = aesCtr.encrypt(textBytes);
        return Aes.utils.hex.fromBytes(encrpytedBytes);

    }
    
    decryptMessage = (encryptedHex) => {
        
        const encrpytedBytes = Aes.utils.hex.toBytes(encryptedHex);
        const keyBytes = Aes.utils.utf8.toBytes(this.state.key);
        const aesCtr = new Aes.ModeOfOperation.ctr(keyBytes);
        const decryptedBytes = aesCtr.decrypt(encrpytedBytes);
        return Aes.utils.utf8.fromBytes(decryptedBytes);
        
    } 

    componentDidMount() {
        const currentUser = this.state.currentUser;
        let matchedUser = null;
               
        function filterMessage(message){
            return ((message.fromId == currentUser.uid && message.toId == matchedUser.uid) || (message.fromId == matchedUser.uid && message.toId == currentUser.uid))
        }

        this.getMatchedUser = this.props.firebase.user(currentUser.matchedUserID).get()
        .then(snapshot => {
            
            const firebaseUser = snapshot.data();
            firebaseUser.uid = snapshot.id;
            if(firebaseUser.matchedUserID == currentUser.uid){
                matchedUser = {
                    ...firebaseUser,
                };
            }
            this.setState({
                matchedUser: matchedUser,
            });
        }).then( () => {

            this.getMessages = this.props.firebase.messages()
              .orderBy("sentTime").onSnapshot(snapshot => {
                let messages = [];
                snapshot.forEach(doc => {
                    let message = { ...doc.data(), mid: doc.id}
                    message.sentTime = moment(message.sentTime).format('LLL');
                    if(filterMessage(message)){
                        message.content = this.decryptMessage(message.content);
                        messages.push(message);
                    }
                });
                this.setState({
                    messages
                })
            });
        });
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    };    
    onSubmit = event => {
        const { currentUser, matchedUser, content, filteredMessages } = this.state;

        const message = {
            toId: matchedUser.uid,
            fromId: currentUser.uid,
            content: this.encryptMessage(content),
            sentTime: moment().format()
        }
        this.props.firebase.db.collection("messages").add({
            ...message
        })

        this.setState({
            content: ""
        })
        
        event.preventDefault();

    }


    render(){
        const {
            messages,
            content,
            matchedUser,
            currentUser
        } = this.state;

        const isInvalid = content == "";
        
        return (
            
            <MDBCard className="chat-room">
                <MDBCardBody>
                    <MDBRow className="px-lg-2 px-2 chat-area">
                        <MDBCol xl="6" className="col">
                            <MDBRow>
                                <MDBListGroup className="list-unstyled">

                                    {messages.map((message, index) => {
                                        if(message.fromId == currentUser.uid){
                                            return <ChatMessage 
                                                key={message.mid + message.sentTime}
                                                message={message}
                                                avatar={currentUser.photoURL}
                                                username={currentUser.username}
                                                uid={currentUser.uid}
                                                />
                                        }else{
                                            return <ChatMessage
                                                key={message.mid + message.sentTime}
                                                message={message}
                                                avatar={matchedUser.photoURL}
                                                username={matchedUser.username}
                                                uid={currentUser.uid}
                                                />
                                        }
                                    })}
                                </MDBListGroup>
                                <div className="form-group basic-textarea">
                                        <textarea className="form-control pl-2 my-0" id="exampleFormControlTextarea2" rows="3"
                                        placeholder="Type your message here..." name="content" value={content} onChange={this.onChange}/>
                                        <Button
                                            disabled={isInvalid}
                                            onClick={this.onSubmit}
                                            >
                                            Send
                                        </Button>
                                </div>
                            </MDBRow>
                        </MDBCol>
                    </MDBRow>
                </MDBCardBody>
            </MDBCard>
        );
    }


}
const condition = authUser => !!authUser;

const ChatPage = compose (
    withAuthorization(condition),
    withFirebase,
    withCurrentUser
)(Chat)
const ChatMessage = ({ message: {fromId, sentTime, content }, avatar, username, uid}) => {
    if(uid == fromId){
        return (
                <li className="chat-message mb-4 message-align-right">
                    <MDBCard className="out-box">
                        <MDBCardBody>
                            <MDBCol sm={8} className="p-0">
                                <MDBRow>
                                    <MDBCol sm={4}>
                                        <Image src={avatar} roundedCircle height={50} width={50}/>
                                    </MDBCol>
                                    <MDBCol>
                                        <MDBRow>
                                            <strong className="primary-font">{username}</strong>
                                        </MDBRow>
                                        <MDBRow>
                                            <small className="pull-right text-muted">
                                                {sentTime}
                                            </small>
                                        </MDBRow>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                            <hr/>
                            <p className="mb-0">{content}</p>
                        </MDBCardBody>
                    </MDBCard>
                </li>
        )
    }else{
        return (
                <li className="chat-message mb-4 message-align-left">
                    <MDBCard className="in-box">
                        <MDBCardBody>
                            <MDBCol sm={8} className="p-0">
                                <MDBRow>
                                    <MDBCol sm={4}>
                                        <Image src={avatar} roundedCircle height={50} width={50}/>
                                    </MDBCol>
                                    <MDBCol>
                                        <MDBRow>
                                            <strong className="primary-font">{username}</strong>
                                        </MDBRow>
                                        <MDBRow>
                                            <small className="pull-right text-muted">
                                                {sentTime}
                                            </small>
                                        </MDBRow>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                            <hr/>
                            <p className="mb-0">{content}</p>
                        </MDBCardBody>
                    </MDBCard>
                </li>
            
        )
    }
    
      
};

export default ChatPage;