import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { render } from '@testing-library/react';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import moment from 'moment';



class Chat extends Component{

    constructor(props){
        super(props);
        this.state = {
            messages: [],
            currentUser: this.props.authUser,
            matchedUser: null,
            content: "",
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
                    if(filterMessage(message)){
                        messages.push(message)
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


    render(){
        const {
            messages,
            content,
        } = this.state;

        const isInvalid = content == "";
        
        return (
            <div>
                <h1>Chat Page</h1>
                <p>The chat page is accsessible when user is successfully matched.</p>
                <ul>
                    {messages.map( message => (
                        <li key={message.mid}>{message.content}</li>
                    ))}
                </ul>

                <input type="text" name="content" value={content} onChange={this.onChange}/>
                <button type="button" className="btn" disabled={isInvalid} onClick={this.onSubmit}>
                    Send
                </button>
            </div>
        );
    }


}
const condition = authUser => !!authUser;

const ChatPage = compose (
    withAuthorization(condition),
    withFirebase,
    withCurrentUser
)(Chat)


export default ChatPage;