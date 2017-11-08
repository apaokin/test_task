class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    hash = message_params.to_h
    mappings = { 'from' => 'sender_id', 'to' => 'receiver_id', 'message' => 'message' }
    upd_hash = {}
    hash.each{ |k, v| upd_hash[mappings[k]] = v }
    @message = Message.new upd_hash
    if @message.save
      render json: { success: true }, status: 200
    else
      # errors = @message.errors[:sender] || @message.errors[:from]
      # errors.push('NICKNAME_TAKEN') if errors
      render json: { success: false, errors: ["USER_NOT_FOUND"] }, status: 400
    end
  end

  def index
    @current_user_id = params[:current_user_id]
    @target_user_id = params[:target_user_id]
    check_ids
    if @errors.empty?
      messages = Message.get_correspondence_and_update @current_user_id,
                                                       @target_user_id
      json_messages = messages.map { |m| m.attributes.except('read') }
      render json: { success: true, messages: json_messages }
    else
      render json: { success: false, errors: @errors },status: 400
    end

  end

  private

  def message_params
    params.permit(:message, :from, :to)
  end

  def check_ids
    @errors = []
    current_user = User.find_by(id: @current_user_id)
    if current_user
      current_user.update! last_online_at: DateTime.now
    else
      @errors.push('CURRENT_USER_NOT_FOUND')
    end
    unless User.find_by(id: @target_user_id)
      @errors.push('TARGET_USER_NOT_FOUND')
    end
  end

end
