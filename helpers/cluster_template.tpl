{
    "apiVersion": "vlabs",
    "location": "",
    "properties": {
        "orchestratorProfile": {
            "orchestratorType": "Kubernetes",
            "orchestratorVersion": "${KUBERNETES_SEM_VERSION}",
            "kubernetesConfig": {
                "kubernetesImageBase": "${HYPERKUBE_REPOSITORY}",
                "useInstanceMetadata": false,
                "networkPlugin": "${NETWORK_PLUGIN}",
                "networkPolicy": "${NETWORK_POLICY}"
            }
        },
        "customCloudProfile": {
            "portalURL": "${AZS_PORTAL_URL}",
            "identitySystem": "${AZS_IDENTITY_PROVIDER}"
        },
        "masterProfile": {
            "dnsPrefix": "",
            "count": ${MASTER_POOL_COUNT},
            "distro": "${MASTER_POOL_DISTRO}",
            "vmSize": "${MASTER_POOL_VMSIZE}"
        },
        "agentPoolProfiles": [
            {
                "name": "linuxpool",
                "count": ${LINUX_POOL_COUNT},
                "distro": "${LINUX_POOL_DISTRO}",
                "vmSize": "${LINUX_POOL_VMSIZE}",
                "availabilityProfile": "AvailabilitySet",
                "AcceleratedNetworkingEnabled": false
            }
        ],
        "linuxProfile": {
            "adminUsername": "azureuser",
            "ssh": {
                "publicKeys": [
                    {
                        "keyData": "${SSH_PUBLIC_KEY}"
                    }
                ]
            }
        },
        "servicePrincipalProfile": {
            "clientId": "",
            "secret": ""
        }
    }
}