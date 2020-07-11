pipeline{

  agent {
    label 'maven'
  }

  environment { 
    // Define global variables
    // Set Maven command to always include Nexus Settings
    // NOTE: Somehow an inline pod template in a declarative pipeline
    //       needs the "scl_enable" before calling maven.
    mvnCmd = "source /usr/local/bin/scl_enable && mvn -s ./nexus_settings.xml"

    // Images and Projects
    imageName   = "${GUID}-weather"
    devProject  = "${GUID}-weather-dev"
    prodProject = "${GUID}-weather-prod"

    // Tags
    devTag      = "0.0-0"
    prodTag     = "0.0"
    
    // Blue-Green Settings
    destApp     = "weather-green"
    activeApp   = ""
  }

  stages{
      stage('Checkout Sourcecode'){
          steps{
              checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Fuangwith-Bkk/weather-app.git']]])
              script {
                    def pom = readMavenPom file: 'pom.xml'
                    def version = pom.version
                    
                    // Set the tag for the development image: version + build number
                    devTag  = "${version}-" + currentBuild.number
                    echo "devTag: ${devTag}"
                    // Set the tag for the production image: version
                    prodTag = "${version}"
                    echo "prodTag: ${prodTag} "

                }
          }
      }

      stage('Build War'){
          
      }
  }

}