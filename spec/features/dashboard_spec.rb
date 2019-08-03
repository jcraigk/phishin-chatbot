# frozen_string_literal: true
require 'rails_helper'

describe 'Dashboard' do
  it 'displays expected content' do
    visit '/'

    within('.welcome') do
      expect(page).to have_content('Welcome to the home')
    end

    within('h1') do
      expect(page).to have_content('Chat Commands')
    end
  end
end
