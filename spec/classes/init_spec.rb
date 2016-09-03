require 'spec_helper'
describe 'soe' do

  context 'with defaults for all parameters' do
    it { should contain_class('soe') }
  end
end
