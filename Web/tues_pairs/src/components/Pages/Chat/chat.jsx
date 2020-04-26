import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import moment from 'moment';
import { MDBCard, MDBCardBody, MDBRow, MDBCol, MDBListGroup, MDBContainer} from "mdbreact";
import "./style.scss";
import { Button, Image, Media, Col} from 'react-bootstrap';
import ScrollableFeed from 'react-scrollable-feed';
import {FaPaperPlane, FaTrash} from 'react-icons/fa';


class Chat extends Component{

    constructor(props){
        super(props);
        this.state = {
            messages: [],
            currentUser: this.props.authUser,
            matchedUser: null,
            content: "",
            lastElement: React.createRef()
        }
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
            if(firebaseUser != undefined){
                firebaseUser.uid = snapshot.id;
                if(firebaseUser.matchedUserID == currentUser.uid){
                    matchedUser = {
                        ...firebaseUser,
                    };
                }
                this.setState({
                    matchedUser: matchedUser,
                });
            }
        }).then( () => {
            if(matchedUser != null){
                this.getMessages = this.props.firebase.messages()
                    .orderBy("sentTime").onSnapshot(snapshot => {
                    let messages = [];
                    snapshot.forEach(doc => {
                        let message = { ...doc.data(), mid: doc.id}
                        message.sentTime = moment(message.sentTime).format('LLL');
                        if(filterMessage(message)){
                            messages.push(message);
                        }
                    });
                    this.setState({
                        messages
                    })
                });
            }
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
            content: content,
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

    onDelete = mid => event => {

        this.props.firebase.db.collection("messages").doc(mid).delete()
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
        if(matchedUser != null){
            return (
                <div class="col-5 px-0 chat-container">
                    <div class="px-4 py-5 chat-box">
                        <div className="scrollable-wrapper">
                            <ScrollableFeed forceScroll={true}>
                                <MDBListGroup>
                                    {messages.map((message, index) => {
                                        if(message.fromId == currentUser.uid){
                                            return <ChatMessage 
                                                key={message.mid + message.sentTime}
                                                message={message}
                                                avatar={currentUser.photoURL}
                                                username={currentUser.username}
                                                uid={currentUser.uid}
                                                onDelete={this.onDelete}
                                                />
                                        }else{
                                            return <ChatMessage
                                                key={message.mid + message.sentTime}
                                                message={message}
                                                avatar={matchedUser.photoURL}
                                                username={matchedUser.username}
                                                uid={currentUser.uid}
                                                onDelete={this.onDelete}
                                                />
                                        }
                                    })}
                                </MDBListGroup>
                            </ScrollableFeed>
                        </div>
                        <div className="bg-light">
                            <div className="input-group">
                                <input type="text" placeholder="Type a message" name="content" value={content} onChange={this.onChange} aria-describedby="button-addon2" className="form-control rounded-0 border-0 py-4 bg-light" />
                                <div className="input-groyp-append">
                                    <button id="button-addon2" type="submit" class="btn btn-link"
                                        disabled={isInvalid}
                                        onClick={this.onSubmit}
                                    > 
                                        <FaPaperPlane/>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            );
        }else if(currentUser.matchedUserID != null){
            return(
                <div className="hint-container">
                    <p>Please wait until your request is approved!</p>
                </div>
            )
        }else{
            return(
                <div className="hint-container">
                    <p>Please send a request and wait for it to be approved so you can chat!</p>
                </div>
            )
        }
    }


}
const condition = authUser => !!authUser;

const ChatPage = compose (
    withAuthorization(condition),
    withFirebase,
    withCurrentUser
)(Chat)
const ChatMessage = ({ message: {mid, fromId, sentTime, content }, avatar, username, uid, onDelete}) => {

    if(uid == fromId){
        return (
            <li>
                <Media className="w-50 ml-auto mb-3 container-reciever">
                    <button class="btn"
                        onClick={onDelete(mid)}
                    >
                        <FaTrash/>
                    </button>
                    <Media.Body className="mr-3 container-content-reciever">
                        <div className="bubble-container-reciever rounded py-2 px-3 mb-2">
                            <p className="text-small mb-0 text-white">{content}</p>
                        </div>
                        <p className="small text-muted">{sentTime}</p>
                    </Media.Body>
                    <Image
                            src={avatar}
                            alt="Reciever profile picture"
                            width={50}
                            height={50}
                            className="rounded-circle"
                            
                    />
                </Media>
            </li>
        )
    }else{
        return (
            <li>
                <Media className="w-50 mb-3 container-sender">
                    <Image
                            src={avatar}
                            alt="Sender profile picture"
                            width={50}
                            height={50}
                            className="rounded-circle"
                    />
                    <Media.Body className="ml-3">
                        <div class="bubble-container-sender rounded py-2 px-3 mb-2">
                            <p class="text-small mb-0">{content}</p>
                        </div>
                        <p class="small text-muted">{sentTime}</p>
                    </Media.Body>
                </Media>
            </li>
        )
    }
    
      
};

export default ChatPage;