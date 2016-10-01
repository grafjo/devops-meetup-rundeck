#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
echo "deb http://ftp.debian.org/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list
apt-get update
# gsettings solves '(process:6319): GLib-GIO-ERROR **: No GSettings schemas are installed on the system'
apt-get install -y openjdk-8-jdk-headless openjdk-8-jre-headless jenkins git gsettings-desktop-schemas vim-nox
update-ca-certificates -f
#apt-get purge -y openjdk-7-jre-headless
#apt-get autoremove -y

mkdir /var/lib/jenkins/jobs/demo-master
cat >> /var/lib/jenkins/jobs/demo-master/config.xml <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <jenkins.model.BuildDiscarderProperty>
      <strategy class="hudson.tasks.LogRotator">
        <daysToKeep>-1</daysToKeep>
        <numToKeep>10</numToKeep>
        <artifactDaysToKeep>-1</artifactDaysToKeep>
        <artifactNumToKeep>-1</artifactNumToKeep>
      </strategy>
    </jenkins.model.BuildDiscarderProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.0.0">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <name>origin</name>
        <refspec>+refs/heads/master:refs/remotes/origin/master</refspec>
        <url>https://github.com/grafjo/devops-meetup-rundeck-demo.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.plugins.gradle.Gradle plugin="gradle@1.25">
      <description></description>
      <switches></switches>
      <tasks>build uploadArchives</tasks>
      <rootBuildScriptDir></rootBuildScriptDir>
      <buildFile></buildFile>
      <gradleName>(Default)</gradleName>
      <useWrapper>true</useWrapper>
      <makeExecutable>false</makeExecutable>
      <fromRootBuildScriptDir>true</fromRootBuildScriptDir>
      <useWorkspaceAsHome>false</useWorkspaceAsHome>
      <passAsProperties>false</passAsProperties>
    </hudson.plugins.gradle.Gradle>
  </builders>
  <publishers>
    <org.jenkinsci.plugins.rundeck.RundeckNotifier plugin="rundeck@3.5.4">
      <rundeckInstance>rundeck</rundeckInstance>
      <jobId>meetup:deploy-demo</jobId>
      <options>repository=snapshots</options>
      <nodeFilters>name: test</nodeFilters>
      <tags/>
      <shouldWaitForRundeckJob>true</shouldWaitForRundeckJob>
      <shouldFailTheBuild>true</shouldFailTheBuild>
      <includeRundeckLogs>false</includeRundeckLogs>
      <tailLog>false</tailLog>
    </org.jenkinsci.plugins.rundeck.RundeckNotifier>
  </publishers>
  <buildWrappers/>
</project>
EOF

chown -R jenkins:jenkins /var/lib/jenkins/jobs/demo-master

systemctl enable jenkins
systemctl start jenkins
