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

execute 'download filebeat' do
 action :run
 command 'curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.3-x86_64.rpm'
end

execute 'install filebeat' do
 action :run
 command 'rpm -vi filebeat-5.6.3-x86_64.rpm'
end

#MOVE FILES
directory '/etc/osquery' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/etc/osquery/DarkLightPacks' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/etc/filebeat' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#/etc/osquery
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/osquery.flags > /etc/osquery/osquery.flags')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/osquery.conf > /etc/osquery/osquery.conf')
#/etc/osquery/DarkLightPacks
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/DarkLightPacks/fim.conf > /etc/osquery/DarkLightPacks/fim.conf')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/DarkLightPacks/events.conf > /etc/osquery/DarkLightPacks/events.conf')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/DarkLightPacks/incident-response.ctci.conf > /etc/osquery/DarkLightPacks/incident-response.ctci.conf')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/DarkLightPacks/it-compliance.conf > /etc/osquery/DarkLightPacks/it-compliance.conf')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/DarkLightPacks/networking.conf > /etc/osquery/DarkLightPacks/networking.conf')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/osquery/DarkLightPacks/syslog.conf > /etc/osquery/DarkLightPacks/syslog.conf')
#/etc/filebeat
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/filebeat/filebeat.full.yml > /etc/filebeat/filebeat.full.yml')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/filebeat/filebeat.template-es2x.json > /etc/filebeat/filebeat.template-es2x.json')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/filebeat/filebeat.template-es6x.json > /etc/filebeat/filebeat.template-es6x.json')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/filebeat/filebeat.template.json > /etc/filebeat/filebeat.template.json')
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/filebeat/filebeat.yml > /etc/filebeat/filebeat.yml')
#/etc/logrotate.d
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/logrotate.d/osquery > /etc/logrotate.d/osquery')
#/etc/rsyslog.d
execute('curl -L https://raw.githubusercontent.com/champtc/Infrastructure/master/osquery/linux-etc/rsyslog.d/osquery_syslog.conf > /etc/rsyslog.d/osquery_syslog.conf')

#CREATE FIFO
execute 'create fifo for syslog' do
 action :run
 command 'mkfifo /var/osquery/syslog_pipe'
end

#SET SELINUX
execute 'set selinux to permissive' do
 action :run
 command 'sed -i "s/enforcing/permissive/g" /etc/selinux/config'
end

#SERVICES
execute 'enable osqueryd service' do
 action :run
 command 'systemctl enable osqueryd'
end

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
