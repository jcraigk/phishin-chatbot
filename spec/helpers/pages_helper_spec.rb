# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PagesHelper do
  subject { helper }

  describe '#user_group_noun' do
    context 'when platform is discord' do
      let(:platform) { :discord }

      it 'returns "team"' do
        expect(helper.user_group_noun(platform)).to eq('guild')
      end
    end

    context 'when platform is slack' do
      let(:platform) { :slack }

      it 'returns "team"' do
        expect(helper.user_group_noun(platform)).to eq('team')
      end
    end
  end
end
