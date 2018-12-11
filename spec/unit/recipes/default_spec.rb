#
# Cookbook:: lc4_jenkins
# Spec:: default
#
# Copyright:: 2018,  Larry Charbonneau
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'spec_helper'

describe 'lc4_jenkins::default' do
  context 'When all attributes are default, on CentOS 7.5.1804' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.5.1804')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs git' do
      expect(chef_run).to install_package('git')
    end

    it 'installs OpenJDK-1.8.0' do
      expect(chef_run).to install_package('java-1.8.0-openjdk')
    end

    it 'adds the jenkins yum repo' do
      expect(chef_run).to create_yum_repository('jenkins')
    end

    it 'installs jenkins' do
      expect(chef_run).to install_package('jenkins-2.89.4')
    end

    it 'enables and starts jenkins' do
      expect(chef_run).to enable_service('jenkins')
    end

    it 'starts jenkins' do
      expect(chef_run).to start_service('jenkins')
    end

    it 'adds the service to firewalld' do
      expect(chef_run).to_not run_execute('add service to firewalld')
    end

    it 'reloads firewalld' do
      expect(chef_run).to_not run_execute('Reload firewall')
    end
  end
end
