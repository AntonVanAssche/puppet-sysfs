# frozen_string_literal: true

require 'spec_helper'

describe 'sysfs' do
  shared_examples 'redhat-7-x86_64' do
    it { is_expected.to contain_file('/usr/local/bin/sysfs-reload').with(owner: 'root', group: 'root', mode: '0700', before: 'File[/etc/systemd/system/sysfsutils.service]') }
    it { is_expected.to contain_file('/etc/systemd/system/sysfsutils.service').with(owner: 'root', group: 'root', mode: '0644', before: 'Service[sysfsutils]') }
    it {
      is_expected.to contain_exec('sysfsutils_reload_rhel')
        .with(
          command: '/usr/bin/awk -F= \'/(\S+)\s*=(\S+)/{cmd=sprintf("/bin/echo %s > /sys/%s",$2, $1); system(cmd)}\' /etc/sysfs.conf',
          refreshonly: true,
          subscribe: 'Concat[/etc/sysfs.conf]',
        )
    }
  end

  shared_examples 'redhat-8-x86_64' do
    it { is_expected.to contain_file('/usr/local/bin/sysfs-reload').with(owner: 'root', group: 'root', mode: '0700', before: 'File[/etc/systemd/system/sysfsutils.service]') }
    it { is_expected.to contain_file('/etc/systemd/system/sysfsutils.service').with(owner: 'root', group: 'root', mode: '0644', before: 'Service[sysfsutils]') }
    it {
      is_expected.to contain_exec('sysfsutils_reload_rhel')
        .with(
          command: '/usr/bin/awk -F= \'/(\S+)\s*=(\S+)/{cmd=sprintf("/bin/echo %s > /sys/%s",$2, $1); system(cmd)}\' /etc/sysfs.conf',
          refreshonly: true,
          subscribe: 'Concat[/etc/sysfs.conf]',
        )
    }
  end

  shared_examples 'redhat-9-x86_64' do
    it { is_expected.to contain_file('/usr/local/bin/sysfs-reload').with(owner: 'root', group: 'root', mode: '0700', before: 'File[/etc/systemd/system/sysfsutils.service]') }
    it { is_expected.to contain_file('/etc/systemd/system/sysfsutils.service').with(owner: 'root', group: 'root', mode: '0644', before: 'Service[sysfsutils]') }
    it {
      is_expected.to contain_exec('sysfsutils_reload_rhel')
        .with(
          command: '/usr/bin/awk -F= \'/(\S+)\s*=(\S+)/{cmd=sprintf("/bin/echo %s > /sys/%s",$2, $1); system(cmd)}\' /etc/sysfs.conf',
          refreshonly: true,
          subscribe: 'Concat[/etc/sysfs.conf]',
        )
    }
  end

  shared_examples 'debian-9-x86_64' do
  end

  shared_examples 'debian-10-x86_64' do
  end

  shared_examples 'debian-11-x86_64' do
  end

  shared_examples 'debian-12-x86_64' do
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('sysfsutils').with(ensure: 'installed') }
      it { is_expected.to contain_service('sysfsutils').with(ensure: 'running', enable: true, subscribe: 'Concat[/etc/sysfs.conf]') }
      it { is_expected.to contain_concat('/etc/sysfs.conf').with(owner: 'root', group: 'root', mode: '0644', force: true, require: 'Package[sysfsutils]') }

      include_examples os

      context 'when settings are defined' do
        let(:params) do
          {
            'settings' => {
              'class/block/sdb/queue/read_ahead_kb' => 8,
              'devices/system/cpu/cpu0/cpufreq/scaling_governor' => 'powersave',
            }
          }
        end

        it { is_expected.to contain_sysfs__setting('class/block/sdb/queue/read_ahead_kb').with(value: 8) }
        it { is_expected.to contain_sysfs__setting('devices/system/cpu/cpu0/cpufreq/scaling_governor').with(value: 'powersave') }
      end
    end
  end
end
