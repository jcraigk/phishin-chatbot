# frozen_string_literal: true
class PagesController < ApplicationController
  def dashboard; end

  def success
    @platform = params[:platform].titleize
    @team = params[:team]
  end
end
