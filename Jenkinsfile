def secrets = [
    [path: params.VAULT_PATH_SVC_ACCOUNT_EPHEMERAL, engineVersion: 1, secretValues: [
        [envVar: 'OC_LOGIN_TOKEN_DEV', vaultKey: 'oc-login-token-dev'],
        [envVar: 'OC_LOGIN_SERVER_DEV', vaultKey: 'oc-login-server-dev']]],
    [path: params.VAULT_PATH_QUAY_PUSH, engineVersion: 1, secretValues: [
        [envVar: 'QUAY_USER', vaultKey: 'user'],
        [envVar: 'QUAY_TOKEN', vaultKey: 'token']]],
    [path: params.VAULT_PATH_RHR_PULL, engineVersion: 1, secretValues: [
        [envVar: 'RH_REGISTRY_USER', vaultKey: 'user'],
        [envVar: 'RH_REGISTRY_TOKEN', vaultKey: 'token']]]
]

def configuration = [vaultUrl: params.VAULT_ADDRESS, vaultCredentialId: params.VAULT_CREDS_ID, engineVersion: 1]

pipeline {
    agent { label 'rhel8' }
    options {
        timestamps()
    }
    environment {
        // --------------------------------------------
        // Options that must be configured by app owner
        // --------------------------------------------
        APP_NAME="CHANGEME"  // name of app-sre "application" folder this component lives in
        COMPONENT_NAME="CHANGEME"  // name of app-sre "resourceTemplate" in deploy.yaml for this component
        IMAGE="quay.io/cloudservices/CHANGEME"  // image location on quay

        IQE_PLUGINS="CHANGEME"  // name of the IQE plugin for this app.
        IQE_MARKER_EXPRESSION="CHANGEME"  // This is the value passed to pytest -m
        IQE_FILTER_EXPRESSION=""  // This is the value passed to pytest -k
        IQE_CJI_TIMEOUT="30m"  // This is the time to wait for smoke test to complete or fail

        CICD_URL="https://raw.githubusercontent.com/RedHatInsights/cicd-tools/main"
    }
    stages {
        stage('Build the PR commit image') {
            steps {
                withVault([configuration: configuration, vaultSecrets: secrets]) {
                    sh 'make build-image'
                }

                sh 'mkdir -p artifacts'
            }
        }

        stage('Run Tests') {
            parallel {
                stage('Run unit tests') {
                    steps {
                        withVault([configuration: configuration, vaultSecrets: secrets]) {
                            sh '''make venv_create \
                                source .venv/bin/activate \
                                make test'''
                        }
                    }
                }

                stage('Run smoke tests') {
                    steps {
                        withVault([configuration: configuration, vaultSecrets: secrets]) {
                            sh '''
                                make smoke-test
                            '''
                        }

                    }
                }
            }
        }
    }
}
