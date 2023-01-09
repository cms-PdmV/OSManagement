# Deploy kubernetes cluster using OpenStack
# Authenticate to OpenStack using a OpenStack RC file for a project
# Use lxplus8.cern.ch to execute this script
# If you want more details, please see https://kubernetes.docs.cern.ch/docs/getting-started/

CLUSTER_NAME=$1

# Change to another Keypair if it is desired
# This Keypair existed before running this script
KEYPAIR_NAME='Kubernetes Development'
VERSION='kubernetes-1.22.9-1'
CHECK_STATUS='openstack coe cluster list'

if [[ -z "$CLUSTER_NAME" ]]; then
    echo "Please specify a cluster name"
    exit 1
fi

echo "Deploying Kubernetes cluster using OpenStack"
echo "Cluster Name: ${CLUSTER_NAME}"
echo "Version: ${VERSION}"
echo "Keypair name: ${KEYPAIR_NAME}"
echo "Creating ................"

# Create cluster
openstack coe cluster create "$1" \
--keypair "$KEYPAIR_NAME" \
--cluster-template "$VERSION" \
--merge-labels \
--labels cern_enabled=true \
--node-count 2 \
--flavor m2.large

echo ""
echo "Creation task submitted"
echo "Check the status using: $CHECK_STATUS"
echo "We are going to do it for you this time"
echo ""

$CHECK_STATUS
