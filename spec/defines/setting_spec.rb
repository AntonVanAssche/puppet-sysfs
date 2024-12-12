# frozen_string_literal: true

require 'spec_helper'

describe 'sysfs::setting' do
  context 'with integer value' do
    let(:title) { 'net/ipv4/ip_forward' }
    let(:params) do
      {
        'value' => 1,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat__fragment('net/ipv4/ip_forward').with(target: '/etc/sysfs.conf', content: %r{net/ipv4/ip_forward=1}) }
  end

  context 'with string value' do
    let(:title) { 'devices/system/cpu/cpu0/cpufreq/scaling_governor' }
    let(:params) do
      {
        'value' => 'powersave',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_concat__fragment('devices/system/cpu/cpu0/cpufreq/scaling_governor')
        .with(
          target: '/etc/sysfs.conf',
          content: %r{devices/system/cpu/cpu0/cpufreq/scaling_governor=powersave},
        )
    }
  end
end
