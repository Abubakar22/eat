require 'openssl'
require 'net/ssh'

include_recipe 'java'
include_recipe 'tomcat'

#Defining variables
appdir  = '/app/eatcicd'
containerdir = "#{appdir}/cicontainer"
jenkinsdir = "#{appdir}/.cijenkins"
user_for_app = 'cijenkins'
grp_for_app = 'cijenkins'
jenkins_source = node.default['eatcicd']['jenkins_source']
jenkins_checksum = node.default['eatcicd']['jenkins_checksum']
service_name = 'cijenkins'

#Install Tomcat
tomcat_install service_name do
  tomcat_user user_for_app
  tomcat_group grp_for_app
  install_path containerdir
end

#Setting up home directory for jenkins webapp
directory jenkinsdir do
  owner user_for_app
  group grp_for_app
  action :create
end

#Copy jenkins war to webapp folder
remote_file "#{containerdir}/webapps/jenkins.war" do
  owner user_for_app
  mode '0644'
  source jenkins_source
  checksum jenkins_checksum
end

#Add jenkins as service
tomcat_service service_name do
  #supports status: true, restart: true
  action [:start, :enable]
  env_vars [{'CATALINA_BASE' => containerdir}, {'CATALINA_PID' => "#{containerdir}/#{service_name}.pid"}, {'JAVA_OPTS' => '-Djenkins.install.runSetupWizard=false -Dport.shutdown=8005 -Dport.http=8080'}, {'JENKINS_HOME' => "#{jenkinsdir}"}]
  sensitive true
  tomcat_user user_for_app
  tomcat_group grp_for_app
end

#Fix restriction on usage of jenkins.CLI
cookbook_file "#{jenkinsdir}/jenkins.CLI.xml" do
  source 'jenkins.CLI.xml'
  owner user_for_app
  group grp_for_app
  action :create
  notifies :restart, 'tomcat_service[cijenkins]'
end

#key1 = OpenSSL::PKey::RSA.new 2048
#private_key1 = key1.to_pem
#public_key1 = "#{key1.ssh_type} #{[key1.to_blob].pack('m0')}"
#print(key1)
#node.run_state[:jenkins_private_key] = private_key1

# Create the Jenkins user with the public key
#jenkins_user 'chef' do
#  public_keys [public_key1]
#end

#jenkins_private_key_credentials 'chef' do
#  id 'chef-key'
#  description 'Jenkins Admin user'
#  private_key  key1
#end


# Set the private key on the Jenkins executor
#node.run_state[:jenkins_private_key] = private_key1

#Install plugins
#node['jenkins']['plugins'].each do |plugin|
#  jenkins_plugin plugin do
#    install_deps true
#    notifies :restart, 'tomcat_service[jenkins]'
#  end
#end
