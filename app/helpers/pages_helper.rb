# frozen_string_literal: true
module PagesHelper
  def user_group_noun(platform)
    case platform.to_sym
    when :discord
      'guild'
    else
      'team'
    end
  end
end
