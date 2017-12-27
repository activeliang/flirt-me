class LineBot::Formats::Templates::Buttons < LineBot::Formats::Template
  attr_accessor :thumbnailImageUrl, :title, :text

  def initialize(text, actions, thumbnailImageUrl: '', title: '')
    @type = 'buttons'
    @text = text
    @actions = actions
    @thumbnailImageUrl = thumbnailImageUrl unless thumbnailImageUrl.blank?
    @title = title unless title.blank?
  end

  private

  def valid_value_type
    super
    @actions.each.with_index do |action, i|
      raise TypeError, "@actions[#{i}] is #{action.class.name}, but expect LineBot::Formats::Action" unless action.is_a?(LineBot::Formats::Action)
    end
  end
end
