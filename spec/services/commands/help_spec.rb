# frozen_string_literal: true
require 'rails_helper'

describe Commands::Help do
  subject(:service) { described_class.new }

  it 'returns the help menu' do
    expect(service.call).to eq(Commands::Help::MENU_TEXT)
  end
end
