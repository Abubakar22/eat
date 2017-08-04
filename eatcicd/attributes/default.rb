node.normal["java"]["jdk_version"] = "8"
default['jenkins']['master']['jvm_options'] = '-Djenkins.install.runSetupWizard=false'
default['jenkins']['plugins'] = [
  'crowd2',
  'artifactory',
  'docker-plugin',
  'sonar',
]
#default['jenkins']['master']['endpoint'] = "http://#{node['jenkins']['master']['host']}:#{node['jenkins']['master']['port']}/cijenkins"
default['eatcicd']['jenkins_source'] = 'http://mirrors.jenkins.io/war-stable/2.19.3/jenkins.war'
default['eatcicd']['jenkins_checksum'] = 'bad23e08ce084fdaaccfb7c76fccf435f62cda30c6095b4b3929fb02a9ab3a36'
