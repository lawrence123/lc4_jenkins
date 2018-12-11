#
# Cookbook:: lc4_jenkins
# Recipe:: default
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

package 'git'
package 'java-1.8.0-openjdk'

yum_repository 'jenkins' do
  description 'jenkins yum repository'
  baseurl 'http://pkg.jenkins-ci.org/redhat-stable/'
  gpgkey 'https://jenkins-ci.org/redhat/jenkins-ci.org.key'
  make_cache true
  action :create
end

package node['lc4_jenkins']['version']

service 'jenkins' do
  action [:start, :enable]
end

firewalld_manager '8080/tcp' do
  action :create
end

firewalld_manager 'reload' do
  action :reload
end

user node['lc4_jenkins']['svcacct'] do
  manage_home true
  comment 'Jenkins Automation Server'
  uid node['lc4_jenkins']['userguid']
  #gid node['lc4_jenkins']['groupid']
  home node['lc4_jenkins']['homedir']
  shell node['lc4_jenkins']['shell']
  password node['lc4_jenkins']['password']
end

directory "#{node['lc4_jenkins']['homedir']}/.ssh" do
  action :create
  user node['lc4_jenkins']['svcacct']
  group node['lc4_jenkins']['svcacct']
  mode '0700'
end

template "#{node['lc4_jenkins']['homedir']}/.ssh/authorized_keys" do
  source 'authorized_keys.erb'
  owner node['lc4_jenkins']['svcacct']
  group node['lc4_jenkins']['svcacct']
  mode '0700'
end

template "#{node['lc4_jenkins']['homedir']}/.ssh/id_rsa" do
  source 'id_rsa.erb'
  owner node['lc4_jenkins']['svcacct']
  group node['lc4_jenkins']['svcacct']
  mode '0700'
end

template '/etc/sudoers.d/jenkins_sudo' do
  source 'jenkins_sudo.erb'
  owner 'root'
  mode '0750'
  action :create
end
