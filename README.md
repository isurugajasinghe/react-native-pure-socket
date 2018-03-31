# react-native-pure-socket
Currently this project support to iOS only
MySocketSingleton .h and .m file import to the your xcode project and 
 then import index.js into react-native project 
 
 then import to your component... 
 
 
 import TestSocket from '../<path>/index'
  
  export class Example extends Component {

//init the socket ...
   var socket = new TestSocket('127.0.0.1',8080)
   
// Emit an event to server
  socket.sendMessage("hello world :)")

// Called when anything is emitted by the server
  socket.onAny((event) => {
  console.log(`called with data: `, event);
});

}


Android comming soon ...! :) Thank you
