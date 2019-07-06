# frozen_string_literal: true
require 'rails_helper'

describe Team do
  subject(:team) { build(:team) }

  it { is_expected.to be_a(ApplicationRecord) }

  it { is_expected.to validate_presence_of(:remote_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:platform) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:platform) }
  it { is_expected.to validate_uniqueness_of(:token).scoped_to(:platform) }
end
