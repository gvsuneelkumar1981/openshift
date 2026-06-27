# openshift

Without Spring Cloud Vault:
App starts → reads application.yml → properties loaded

With Spring Cloud Vault:
App starts → connects to Vault → reads secrets →
merges with application.yml → properties loaded

No OCP Secret needed!
App reads directly from Vault at startup.


Vault Pod (OCP)
        ↑
        │ reads secrets at startup
        │
Spring Boot App
        │
        └── db.password = ${vault fetched value}
            mq.password = ${vault fetched value}
            api.key     = ${vault fetched value}

Note: If already present or in failed state then
# Check helm releases
helm list -n gvsuneelkumar1981-dev

helm uninstall vault -n gvsuneelkumar1981-dev

# Install Vault in OCP using Helm (this is not working in sandbox, so go to "Vault::Manual Deploy:")
helm install vault hashicorp/vault \
--namespace gvsuneelkumar1981-dev \
--set "global.openshift=true" \
--set "server.dev.enabled=true" \
--set "server.dev.devRootToken=myroot" \
--set "injector.enabled=false"

Vault::Manual Deploy: (solved the mount dir issue, it was trying to write to root)
=================================================================================
oc apply -f platform-chart/vault/vault-deploy.yaml
oc logs -f deployment/vault

# Get vault pod name
export VAULT_POD=$(oc get pods -l app=vault \
-o jsonpath='{.items[0].metadata.name}')
echo $VAULT_POD
# Exec into pod
oc exec -it $VAULT_POD -- /bin/sh

# Set env vars
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='myroot'

# Verify Vault is ready
vault status


vault kv get myapp/secret/order-service/dev/credentials
vault kv get myapp/secret/order-service/uat/credentials
vault kv get myapp/secret/order-service/prod/credentials