# frozen_string_literal: true
class Commands::Base
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include CommandsHelper

  attr_reader :keyword, :option

  def initialize(keyword: nil, option: nil)
    @keyword = keyword.to_s
    @option = option.to_s
  end
end
