require 'spec_helper'
require 'product'

describe Product do
  let(:subject) { described_class.new(:a_name, 200) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:price) }
end
