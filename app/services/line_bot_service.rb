class LineBotService
  require 'line/bot'

  attr_reader :bot, :chats

  def initialize(request)
    @body = request.raw_post
    @signature = request.env['HTTP_X_LINE_SIGNATURE']
    @bot = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
    @chats = @bot.parse_events_from(@body)
  end

  def reply
    valid_signature
    @chats.each do |chat|
      token = chat['replyToken']
      message = bulid_reply_message(chat)
      next if message.blank?

      @bot.reply_message token, message
    end
  end

  private

  def valid_signature
    raise 'signature invalid' unless @bot.validate_signature(@body, @signature)
  end


  def bulid_reply_message(chat)
    # write your reply logic here
    case chat
    when Line::Bot::Event::Message
      text = chat.message.fetch('text') { '' }
      text[0..1].casecmp('撩我').zero? ? Dialogue.line_msg.to_h : ''
    when Line::Bot::Event::Postback
      data = chat.postback.fetch('data') { '' }
      data = ActionController::Parameters.new(Rack::Utils.parse_nested_query(data))
      if data[:action] == 'flirting'
        Dialogue.line_msg(data[:dialogue_id], data[:sequence]).to_h
      elsif data[:action] == 'voting'
      end
    end
  end
end
