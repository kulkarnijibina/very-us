class ChatTestsController < ApplicationController
  require 'json_web_token'

  layout 'chat_layout'

  def show
  end

  def connect
    current_user = User.where(contact: params[:sender_contact]).last
    receiver = User.where(contact: params[:receiver_contact]).last
    chat= current_user.couple_profile.chats.where(id: User.find(receiver.id).couple_profile.chats.pluck(:id)).first
    if  chat
      chat
    else
      chat = Chat.create
      second_user = User.find(receiver.id)
      chat.couple_profiles << second_user.couple_profile
      chat.couple_profiles << current_user.couple_profile
    end
    sender_token = JsonWebToken.encode({ user_id: current_user.id })
    JsonWebToken.add_token(current_user, sender_token)

    respond_to do |format|
      format.json { render json: {chat_id: chat.id,token:sender_token }}
    end
  end
end
