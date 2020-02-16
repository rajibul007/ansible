[![Build Status](https://engci-private-rtp.cisco.com/jenkins/sto/buildStatus/icon?job=SecureCommonCloudComponents/pipeline/ansible/ansible-kubernetes_hardening)](https://engci-private-rtp.cisco.com/jenkins/sto/job/SecureCommonCloudComponents/job/pipeline/job/ansible/job/ansible-kubernetes_hardening/)

ansible-kubernetes_hardening
=========

This role is used to harden a Kubernetes cluster based off of the CIS Kubernetes Benchmark v1.4.0.

Requirements
------------

A supported version of Ansible must be installed on a controlling node that is connected to the Cisco network. To see which versions of Ansible are currently supported and the platform requirements, please refer to the [ansible-setup vars file](https://wwwin-github.cisco.com/sto-ccc/ansible-setup/blob/master/vars/main.yml)

For more information on installing Ansible, please refer to the [official documentation](http://docs.ansible.com/ansible/intro_installation.html#installation)


How this role affects your cluster
--------------
This role implements the changes suggested in the CIS Kuberentes Benchmark v1.4.0. The benchmark covers a vast number of Kubernetes configuration settings, including things such as: port numbers, request timeouts, maximum number of logs to keep, and various security settings, among other things.

Additionally, this role will create the following components on your cluster, as recommended by the benchmark:

- PodSecurityPolicies
- ClusterRoles for the PodSecurityPolicies
- RoleBinding that binds a ClusterRole to the default namespace
- RoleBinding that binds a ClusterRole to the kube-system namespace
- Audit Policy
- EncryptionConfig (with *aescbc* as the encryption provider)
- EventRateLimit

These components are defined in Jinja2 templates that are located in this role's [templates](https://wwwin-github.cisco.com/sto-ccc/ansible-kubernetes_hardening/tree/master/templates) folder. For more information about these various components and what they do, please see the [Kubernetes reference documentation](https://kubernetes.io/docs/reference/).

It is recommended that you are familiar with these components and all of the role variables (explained in more detail below) in order to understand the impact that this role will have on your Kubernetes cluster. Furthermore, it is also recommended to review the provided templates to ensure that they best meet the needs of your particular cluster.

Role Variables
--------------
There are a vast [number of solutions](https://kubernetes.io/docs/setup/) that can be used set up a Kubernetes cluster. Many of the solutions have their own unique file names and file locations.  In addition to that, the various solutions use different versions of [Kubernetes](https://github.com/kubernetes/kubernetes) itself. Different versions of Kubernetes means different features being available/unavailable, among other things.

Because of this, it would be near impossible to make this a one-size-fits-all role. While the CIS benchmark gives many recommendations, the reality is that the recommendations given might not be applicable - or even impossible to implement - given the solution chosen.

This role currently provides default values for Kubernetes clusters that were originally set up with either the [Kubespray](https://github.com/kubernetes-incubator/kubespray) (version > 2.8.x) solution, Cisco's own [Maglev](http://maglev.cisco.com/) (version 1.2.0.2087) solution, manually via [Kubeadm](https://github.com/kubernetes/kubeadm), Amazon EKS, or Google GKE.

In order for the role to select the proper defaults, as well as perform solution-specific tasks, it is very important that the following variable is set appropriately:

    kubernetes_solution:
        string: "kubespray" (default)
        Solution originally used to set up kubernetes cluster. This has an effect on hardening and is required to be set.
        Must be set to one of the following: kubespray, kubeadm, maglev, eks, gke

An empty dictionary called *cluster_defaults_override* exists to override various cluster-specific default values in one place.

Any value value that you override in this dictionary will be used.  Otherwise, the value in the appropriate vars file will be used by default.

For example, If *kubernetes_solution* is set to "maglev", the *secure_port* value will be set to "9443" by default, as you can see in the *cluster_defaults*
dictionary located at [vars/maglev-vars.yml](https://wwwin-github.cisco.com/sto-ccc/ansible-kubernetes_hardening/blob/master/vars/maglev-vars.yml). However, you can override the *secure_port* value if you need to - while still keeping all of the other Maglev defaults intact - by overriding the *cluster_defaults_override* dictionary and providing the secure_port value. Please see the example playbook below to see how this can be done.

Below you can find all of the possible items that can be set in *cluster_defaults_override* and a description of each item. Each item should be a string unless otherwise noted:

    cluster_defaults_override:
       api_server_specification_file:                 API server pod specification file location
       scheduler_specification_file:                  Scheduler pod specification file location
       controller_manager_specification_file:         Controller Manager pod specification file location
       scheduler_kubeconfig_file:                     kubeconfig file for the Scheduler
       controller_manager_kubeconfig_file:            kubeconfig file for the Controller Manager
       node_kubeconfig_file:                          kubeconfig file for the node.
       proxy_kubeconfig_file:                         kubeconfig file for the kube-proxy
       admin_conf_file:                               file that contains admin credentials for the cluster
       etcd_env_file:                                 file of environment variables for etcd. If your cluster uses a manifest/specification file instead, put that file location here.
       kubelet_env_file:                              file of environment variables for kubelet. If your cluster uses a manifest/specification file instead, put that file location here.
       secure_port:                                   the port on which to serve HTTPS with authentication and authorization
       audit_log_path:                                the desired audit log path
       worker_tls_cert_file:                          worker TLS cert file
       worker_tls_private_key_file:                   worker TLS private key file
       kubelet_certificate_authority:                 kubelet certificate authority for the api server to verify
       kubelet_client_certificate:                    kubelet client certificate file for certificate-based authentication between the api server and kubelets
       kubelet_client_key:                            kubelet client key file for certificate-based authentication between the api server and kubelets
       service_account_key_file:                      public key for signing service account tokens
       etcd_certfile:                                 etcd certificate file for the API server to identify itself to the etcd server
       etcd_keyfile:                                  etcd key file for the API server to identify itself to the etcd server
       etcd_peer_certfile:                            etcd peer certificate file to make use of TLS encryption for peer connections
       etcd_cafile:                                   certificate authority file for TLS connection between the apiserver and etcd
       etcd_data_directory:                           etcd data directory
       etcd_is_cluster:                               Boolean. Set to true if you are using an etcd cluster. Set to false if you are using only one etcd server in your environment.
       etcd_peer_keyfile:                             etcd peer key file to make use of TLS encryption for peer connections
       etcd_wal_dir:                                  path to the dedicated wal directory. If this flag is set, etcd will write the WAL files to the walDir rather than the dataDir.
       tls_cert_file:                                 API server TLS certificate file
       tls_private_key_file:                          API server TLS private key file
       client_ca_file:                                client certificate authority file for TLS connection on the apiserver
       service_account_private_key_file:              service account private key file for service accounts on the controller manager
       root_ca_file:                                  root certificate for the API server's serving certificate to the controller manager
       encryption_config_file_template:               template used to create encryption config file
       audit_policy_file_template:                    template used to create audit policy file
       admission_control_config_file_template:        template used to create admission configuration file
       event_config_file_template:                    template used to create EventConfig file
       pod_security_policy_kube_system_file_template: template used to create the kube-system namespace pod security policy
       pod_security_policy_default_file_template:     template used to create the default namespace pod security policy
       role_kube_system_file_template:                template used to create the role that uses the kube-system namespace pod security policy
       role_default_file_template:                    template used to create the role that uses the default namespace pod security policy
       role_binding_default_file_template:            template used to create RoleBinding file for the default namespace
       role_binding_kube_system_file_template:        template used to create RoleBinding file for the kube-system namespace
       kubectl_user:                                  User with kubectl access on the master node.  Used to create pod security policy, cluster role, and role bindings
       master_pki_directory:                          path to the PKI directory on the master node

##### Everything else

    create_audit_policy_file:
        Boolean: true (default)
        Whether or not to create the audit policy file using audit_policy_file_template

    audit_policy_file_location:
        string: "/etc/kubernetes/audit-policy.yaml" (default)
        Location of the audit policy file. the audit_policy_file_template will be copied to this location if create_audit_policy_file is set to true

    create_encryption_config_file:
        Boolean: true (default)
        Whether or not to create the encryption config file using encryption_config_file_template

    encryption_config_file_location:
        string: "/etc/kubernetes/EncryptionConfig" (default)
        Location of the encrytion config file. the encryption_config_file_template will
        be copied to this location if create_encryption_config_file is set to true

    create_admission_control_config_file:
        Boolean: true (default)
        Whether or not to create the admission control config file using admission_control_config_file_template

    admission_control_config_file_location:
        string: "/etc/kubernetes/AdmissionConfiguration" (default)
        Location of the admission control config file. the admission_control_config_file_template will be copied to this location if create_admission_control_config_file is set to true

    create_event_config_file:
        Boolean: true (default)
        Whether or not to create the event config file using event_config_file_template

    event_config_file_location:
        string: "/etc/kubernetes/eventconfig.yaml" (default)
        Location of the event config file. the event_config_file_template will be copied to this location if create_event_config_file is set to true

    create_pod_security_policy_kube_system_file:
        Boolean: true (default)
        Whether or not to create the kube-system namespace pod security policy file using pod_security_policy_kube_system_file_template

    pod_security_policy_kube_system_file_location:
        string: "/etc/kubernetes/pod-security-policy-kube-system.yaml" (default)
        Location of the kube-system namespace pod security policy file. the pod_security_policy_kube_system_file_template will be copied to this location if create_pod_security_policy_kube_system_file is set to true

    create_pod_security_policy_default_file:
        Boolean: true (default)
        Whether or not to create the default namespace pod security policy file using pod_security_policy_default_file_template

    pod_security_policy_default_file_location:
        string: "/etc/kubernetes/pod-security-policy-default.yaml" (default)
        Location of the default namespace pod security policy file. the pod_security_policy_default_file_template will be copied to this location if create_pod_security_policy_default_file is set to true

    create_role_kube_system_file:
        Boolean: true (default)
        Whether or not to create the kube-system namespace cluster role file using role_kube_system_file_template

    role_kube_system_file_location:
        string: "/etc/kubernetes/role-kube-system.yaml"
        location of the kube-system namespace cluster role file. the role_kube_system_file_template will be copied to this location if create_role_kube_system_file is set to true

    create_role_default_file:
        Boolean: true (default)
        Whether or not to create the default namespace cluster role file using role_default_file_template

    role_default_file_location:
        string: "/etc/kubernetes/role-default.yaml"
        location of the default namespace cluster role file. the role_default_file_template will be copied to this location if create_role_default_file is set to true

    create_role_binding_default_file:
        Boolean: true (default)
        Whether or not to create the role binding file for the default namespace using role_binding_default_file_template

    role_binding_default_file_location:
        string: "/etc/kubernetes/role-binding-default.yaml" (default)
        location of the role binding file for the default namespace. the role_binding_default_file_template will be copied to this location if create_role_binding_default_file is set to true

    create_role_binding_kube_system_file:
        Boolean: true (default)
        Whether or not to create the role binding file for the kube-system namespace using role_binding_kube_system_file_template

    role_binding_kube_system_file_location:
        string: "/etc/kubernetes/role-binding-kube-system.yaml"
        Location of the role binding file for the kube-system namespace. the role_binding_kube_system_file_template will be copied to this location if create_role_binding_kube_system_file is set to true

    audit_log_path:
        string: "/var/log/apiserver/audit.log" (default)
        The desired audit log path

    audit_log_maxage:
        string: "180" (default)
        The number of days to retain audit logs

    audit_log_maxbackup:
        string: "10" (default)
        The number of old log files to keep before discarding

    audit_log_maxsize:
        string: "100" (default)
        The max log file size in MB before the audit logs are rotated

    terminated_pod_gc_threshold:
        integer: 10 (default)
        Terminated pod garbage collection threshold. This is the number of terminated pods that can exist before the terminated pod garbage collector starts deleting terminated pods. If <= 0, the terminated pod garbage collector is disabled, which is not recommended.

    request_timeout:
        string: "60s" (default)
        Global request timeout, in seconds, for API server requests

    secure_port:
        string: "6443" (default)
        The secure port used to serve https with authentication and authorization. This number should be an integer between 1 and 65535

    etcd_is_cluster:
        boolean: true (default)
        Set to true if you are using an etcd cluster. Set to false if you are using only one etcd server
        in your environment. The value of this boolean has an effect on hardening etcd

    etcd_wal_dir:
        string: "/var/lib/etcd-logs/" (default)
        Path to the dedicated wal directory.
        If this flag is set, etcd will write the WAL files to the walDir rather than the dataDir.
        This allows a dedicated disk to be used, and helps avoid io competition between logging and other IO operations

    kubelet_streaming_connection_idle_timeout:
        string: "5m" (default)
        Connection timeout setting for kubelets. Setting idle timeouts ensures that you are protected against Denial-of-Service
        attacks, inactive connections and running out of ephemeral ports.

    kubelet_manages_iptables:
        boolean: true (default)
        Kubelets can automatically manage the required changes to iptables based on how
        you choose your networking options for the pods.
        If your kubelets are managing iptables, set this to true

    rotate_kubelet_client_certificate:
        boolean: true (default)
        Set to true if your cluster lets let kubelets get their client certificates from
        the API server. If your kubelet certificates come from an outside authority/tool
        (e.g. Vault) then set this to false. The value of this boolean has an effect on hardening worker nodes

    rotate_kubelet_server_certificate:
        boolean: true (default)
        Set to true if your cluster lets kubelets get their server certificates from
        the API server. If your kubelet certificates come from an outside authority/tool
        (e.g. Vault) then set this to false. The value of this boolean has an effect on hardening worker nodes

    api_server_mount_path:
        string: "/etc/kubernetes" (default)
        The mountPath for the API server volumeMount that gets added to the API server manifest file if necessary

    api_server_host_path:
        string: "/etc/kubernetes" (default)
        The hostPath for the API server volume that gets added to the API server manifest file if necessary

    setup_k8s_firewall_rules:
        boolean: false (default)
        Set to true in order to add firewall rules to each machine in the cluster
        using Cloud9's ansible-firewall role

    add_only_k8s_firewall_rules:
        boolean: true (default)
        To be used in combination with {{ setup_k8s_firewall_rules }}
        If set to true, only kubernetes firewall rules will be added to iptables
        If set to false, all actions in ansible-firewall will be performed in addition to adding kubernetes firewall rules.
        It is recommended that this variable is left set to true.

    master_iptables_rules:
        List of dictionaries that defines the iptables rules for master nodes.
        See: https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports
        The default list is as follows:
            - chain: INPUT
              protocol: tcp
              destination_port: "{{ cluster['secure_port'] }}"
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "Kubernetes API Server"
            - chain: INPUT
              protocol: tcp
              destination_port: 2379:2380
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "etcd server client API"
            - chain: INPUT
              protocol: tcp
              destination_port: 10250
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "Kubelet API"
            - chain: INPUT
              protocol: tcp
              destination_port: 10251
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "kube-scheduler"
            - chain: INPUT
              protocol: tcp
              destination_port: 10252
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "kube-controller-manager"

    worker_iptables_rules:
        List of dictionaries that defines the iptables rules for worker nodes.
        See: https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports
        The default list is as follows:
            - chain: INPUT
              protocol: tcp
              destination_port: 2379:2380
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "etcd server client API"
            - chain: INPUT
              protocol: tcp
              destination_port: 10250
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "Kubelet API"
            - chain: INPUT
              protocol: tcp
              destination_port: 30000:32767
              ctstate: NEW,ESTABLISHED
              jump: ACCEPT
              comment: "NodePort Services"

    tune_kernel_parameters:
      boolean: true (default)
      Whether or not to tune kernel parameters prior to hardening

    sysctl_file_path:
      string: "/etc/sysctl.d/99-sysctl.conf" (default)
      Location of the file that is used to write kernel parameters to

    ami_creation:
      boolean: false (default)
      Skips checking for running kubelet when True. Used when creating a prehardened AMI
      The default configuration files for the solution are used.


Example Usage
----------------

##### Install the role's dependencies

  If you'd like to install these dependencies in _/etc/ansible/roles/_, run the following:

      [sudo] ansible-galaxy install -r requirements.yml

  You can also specify a specific path to download the role to via the -p flag:

      [sudo] ansible-galaxy install -r requirements.yml -p /some/specific/directory

##### Inventory File named *kubernetes-hosts.ini*

    [cluster_machines]
    master-0 ansible_ssh_host=18.220.247.130 ansible_user=centos ansible_ssh_private_key_file=~/keys/mykey.pem
    worker-0 ansible_ssh_host=18.191.210.151 ansible_user=centos ansible_ssh_private_key_file=~/keys/mykey.pem
    worker-1 ansible_ssh_host=18.219.215.97 ansible_user=centos ansible_ssh_private_key_file=~/keys/mykey.pem

##### Playbook named *harden-kubernetes.yml*

    - name: Harden K8s Cluster
      hosts: cluster_machines

      vars:

        # Solution used to set up cluster
        kubernetes_solution: "maglev"

        # Example of overriding solution-specific defaults
        cluster_defaults_override:
          secure_port: "7443"

        # Example of overriding a general, non-solution-specific default.
        terminated_pod_gc_threshold: 8

      roles:
        - { role: ansible-kubernetes_hardening }

##### Command to run

    ansible-playbook harden-kubernetes.yml -i kubernetes-hosts.ini


License
-------

Cisco Internal

Author Information
------------------

Cloud 9 Team

[Team site](https://go2.cisco.com/cloud9)

[Webex Teams Support Space](https://eurl.io/#Hk00RFUbm)
