import { NativeModules,NativeEventEmitter } from 'react-native'

const { MySocketSingleton } = NativeModules;
const NativeAppEventEmitter = new NativeEventEmitter(MySocketSingleton);

class TestSocket  {
    constructor (host, port) {
        if(typeof host === 'undefined')
        throw 'Hello there! Could you please give socket a host, please.';
      if(typeof port === 'undefined')
        port = {};

        this.sockets = MySocketSingleton;
        this.handlers = {};
        this.onAnyHandler = null;

        this.deviceEventSubscription = NativeAppEventEmitter.addListener(
            'EventReminder', this._handleEvent.bind(this)
          );
    
        // Set initial configuration
        this.sockets.initNetworkCommunicationUrl(host, port);
        }

        _handleEvent (event) {
        if(this.onAnyHandler) 
        this.onAnyHandler(event.message);
        }
        //write
        sendMessage(sendMessg) {
            MySocketSingleton.sendString(sendMessg)
        }

        //listen 
        onAny (handler) {
            this.onAnyHandler = handler;
        }
}


module.exports = TestSocket;

