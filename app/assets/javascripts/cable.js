// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

const ready = function(){
  $('#send_message').hide();
  $('#disconnect').hide();
  $("#connect").click(function(e) {
    e.preventDefault();
    $.ajax({
      method: 'POST',
      url: '/chat_test/connect',
      data: $("#connect_form").serialize(),
      success: function (data) {
        const token = data["token"];
        const chatId = data["chat_id"];
        connectWebsocket(token);
        connectChannels(chatId);
        $('#send_message').show();
        $('#disconnect').show();
        $('#connect').hide();
      },
      error: function(data){
        console.log(data);
      }
    });
  });

  $("#send").click(function(e) {
    e.preventDefault();
    chatChannel.perform("speak",{ body: $("#content").val() })
  });

  $('#disconnect').click(function(e){
    e.preventDefault();
    AppConst.cable.subscriptions.consumer.disconnect();
    AppConst.cable.disconnect();
    $('#send_message').hide();
    $('#disconnect').hide();
    $('#connect').show();
  });
};

const connectWebsocket = function(token){

  function getWebSocketURL() {
    const url = window.location.origin;
    // const url = "http://52.2.94.174"
    return `${url}/cable?Authorization=${token}`;
  }

  AppConst.cable = ActionCable.createConsumer(getWebSocketURL());
}

const connectChannels = function(chatId){

  chatChannel = AppConst.cable.subscriptions.create({ channel: "ChatChannel", chat_id: chatId  }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('ChatChannel connected');
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log('ChatChannel disconnected');
    },

    rejected: function() {
      console.log("ChatChannel rejected");
    },

    received(data) {
      console.log(data);
      $('#live_chat').append(this.renderMessage(data));
    },

    renderMessage(data) {
      if(data.type == "message"){
        return "<p>" + data.couple_profile_id + " sent message: " + data.body + "</p>";
      }else if(data.type == "meetup"){
        return "<p>" + data.source_couple_id + " sent meetup: " + data.description + "</p>";
      };
    }
  });

  ChatListChannel = AppConst.cable.subscriptions.create({ channel: "ChatListChannel"}, {
    connected() {
      console.log('ChatListChannel connected');
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log('ChatListChannel disconnected');
    },

    rejected: function() {
      console.log("ChatListChannel rejected");
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data);
      $('#all_chats').append(this.renderMessage(data));
    },

    renderMessage(data) {
      if(data.type == "message"){
        return "<p>" + data.couple_profile_id + " sent message: " + data.body + "</p>";
      }else if(data.type == "meetup"){
        return "<p>" + data.source_couple_id + " sent meetup: " + data.description + "</p>";
      };
    }
  });
}

let AppConst = {};
let chatChannel = null;
let ChatListChannel = null;

(function() {
  $(document).ready(ready);
}).call(this);
