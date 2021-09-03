node {
    stage ('Configure dependencies') {
        sh "curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b ./"
	sh "mkdir -p /etc/data"
    }

    stage('Pulling repo') {
        git url: 'https://github.com/davidecostantini/litecoin.git'
    }
    
    stage('Building Docker image') {
        dir('docker') {
           sh "./build.sh"
        }        
    }
    
    stage('Scanning docker image with grype/anchore') {
        sh "./grype litecoin --scope all-layers"
    }
    
    stage('Deploy service to k8s') {
        sh "export KUBECONFIG=/etc/data/secrets/auth.yaml; kubectl apply -f k8s/litecoin.yaml"
    }
}
