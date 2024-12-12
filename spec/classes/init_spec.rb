require 'spec_helper'
describe 'sysfs' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('sysfs') }
  end
end
