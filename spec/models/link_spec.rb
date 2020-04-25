require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  INVALID_URLS = %w[http:///foo.com buz http:// http://http:// https://rails. https://rails rails.com https://rails.com\questions].freeze
  it { should_not allow_values(INVALID_URLS).for(:url) }
end
