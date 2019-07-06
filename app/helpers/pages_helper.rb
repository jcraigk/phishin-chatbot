# frozen_string_literal: true
module PagesHelper
  def user_group_noun(platform)
    return 'guild' if platform.to_sym == :discord
    'team'
  end
end
