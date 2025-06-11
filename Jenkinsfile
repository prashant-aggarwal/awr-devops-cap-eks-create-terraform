pipeline {
    agent any

	// Set the environment variables
    environment {
        AWS_REGION = 'us-east-1'
        CUSTOM_BIN = "${env.HOME}/bin"
        PATH = "${env.HOME}/bin:${env.PATH}"
    }

	// Multistage pipeline
    stages {
		// Stage 1 - Checkout code repository
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'Github',
                    url: 'https://github.com/prashant-aggarwal/awr-devops-cap-eks-create-terraform.git'
            }
        }

		// Stage 1 - Install Terraform
        stage('Install Terraform') {
            steps {
                sh '''
                echo "Installing terraform..."
                curl -O https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip
				unzip terraform_1.12.2_linux_amd64.zip
				chmod +x ./terraform
				mkdir -p $HOME/bin
				cp ./terraform $HOME/bin/terraform
				export PATH=$HOME/bin:$PATH
				terraform version
                '''
            }
        }
		
		stage('Deploy Terraform') {
            steps {
                sh '''
					ls -la
                    terraform --version
                    terraform init
                    terraform plan
                    //terraform apply -auto-approve
                '''
            }
		}
    }

    // Cleanup the workspace in the end
	post {
        always {
            cleanWs()
        }
    }
}
