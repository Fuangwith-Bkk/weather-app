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

              dir('code'){
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
      }

      stage('Build War'){
          steps {
            dir('code') {
                echo "Building version ${devTag}"
                script {

                    //TBD: Execute the Maven Build
                    // mvn clean package -DskipTests=true -s ./nexus_settings.xml
                    // source /usr/local/bin/scl_enable && mvn -s ./nexus_settings.xml
                    sh "$mvnCmd -DskipTests=true clean package"

                }
            }
          }
      }

      // Using Maven run the unit tests
    stage('Unit Tests') {
      steps {
        dir('code') {
            echo "Running Unit Tests"
            // mvn test -s ./nexus_settings.xml
            sh "$mvnCmd test" 

        }
      }
    }

    // Using Maven call SonarQube for Code Analysis
    stage('Code Analysis') {
      steps {
        dir('code') {
          script {
            echo "Running Code Analysis"

            // TBD: Execute Sonarqube Tests
            //      Your project name should be "${GUID}-${JOB_BASE_NAME}-${devTag}"
            //      Your project version should be ${devTag}

            def sonarHost = "http://sonarqube.demo-sonarqube.svc.cluster.local:9000"
            def projectName = "${JOB_BASE_NAME}-${devTag}" //JOB_BASE_NAME or Jenkins Task must have no space
            echo "Project Name: ${projectName}"
            sh "$mvnCmd sonar:sonar -Dsonar.host.url=${sonarHost} -Dsonar.projectName=${projectName} -Dsonar.projectVersion=${devTag}"

          }
        }
      }
    }


  }

}

