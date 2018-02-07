#
# Cookbook:: dl-osquery
# Recipe:: default
#
# Copyright:: 2018, Champion Technology Company, All Rights Reserved.

#DOWNLOAD AND INSTALL
execute 'get osquery package' do
 action :run
 command 'rpm -ivh https://osquery-packages.s3.amazonaws.com/centos7/noarch/osquery-s3-centos7-repo-1-0.0.noarch.rpm'
end

execute 'install osquery' do
 action :run
 command 'yum -y install osquery'
end

execute 'download and install filebeat' do
 action :run
 command 'curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.3-x86_64.rpm  && rpm -vi filebeat-5.6.3-x86_64.rpm'
end

#MOVE FILES
execute 'copy filebeat directory' do
 action :run
 command 'cp -f /tmp/chef-repo/cookbooks/dl-osquery/files/filebeat/ /etc/filebeat'
end

execute 'copy osquery directory' do
 action :run
 command 'cp -f /tmp/chef-repo/cookbooks/dl-osquery/files/osquery-conf/ /etc/osquery'
end

cookbook_file '/etc/logrotate.d/osquery' do
  source 'osquery'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/etc/rsyslog.d/osquery_syslog.conf' do
  source 'osquery_syslog.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#CREATE FIFO
execute 'create fifo for syslog' do
 action :run
 command 'mkfifo /var/osquery/syslog_pipe'
end

#SERVICES
execute 'enable rsyslog service' do
 action :run
 command 'systemctl enable rsyslog'
end

execute 'enable filebeat service' do
 action :run
 command 'systemctl enable filebeat'
end

execute 'start rsyslog service' do
 action :run
 command 'service rsyslog start'
end

execute 'start filebeat service' do
 action :run
 command 'service filebeat start'
end

execute 'start osqueryd service' do
 action :run
 command 'osqueryctl start'
end