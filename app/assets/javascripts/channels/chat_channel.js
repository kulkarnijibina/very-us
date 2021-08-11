// import consumer from "./consumer"

// const chatChannel = consumer.subscriptions.create({ channel: "ChatChannel" }, {
//   connected() {
//     // Called when the subscription is ready for use on the server
//     chatChannel.send({ some: "data" })
//   },

//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },

//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//     $("#chating").removeClass('hidden')
//     return $('#chating').append(this.renderMessage(data));
//   },

//   renderMessage(data) {
//     return "<p>" + data.user + " is chating... in chatroom: " + data.chatroom_id + "</p>";
//   }
// });
