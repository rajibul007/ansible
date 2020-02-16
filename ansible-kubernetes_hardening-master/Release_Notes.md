ansible-kubernetes_hardening - Release Notes
===========

***
Current-Version: 1.1.1
***

__Changes Included In Next Release:__

1. CCC-1555: Separate pod security policies for default and kube-system namespaces

__Release Tag 1.1.0 - 04-December-2019 (Hardening checked with sto-ccc/specs 0.14.0)__

1. CCC-1382: Merge docker-beside-docker CI functionality to base-ci container
2. CCC-1399: Updates for k8s 1.16 support

__Release Tag 1.0.0 - 21-August-2019 (Hardening checked with sto-ccc/specs 0.13.0)__

1. CCC-995: Update role to support kubespray > 2.8
2. CCC-752: Update to use new dynamic pool
3. CCC-876: Harden TLS Cipher list for k8s
4. CCC-1068: k8s single node cluster support and overall improvements
5. CCC-1079: Update vars to use ansible_hostname
6. CCC-1081: Include BOM management
7. CCC-1072:  Ensure kernel parameters are set prior to hardening
8. CCC-1145: Properly escape kubelet args in kubeadm; improve handler
9. CCC-1106: Ability to harden Amazon EKS nodes
10. CCC-1169: Ability to create hardened EKS AMI via ami_creation variable
11. CCC-1107: Ability to harden Google GKE nodes
12. CCC-1201: Change format of variable to pass to ansible-firewall
13. CCC-1187: Kubernetes Jenkins Jobs relocated to be consistent
14. CCC-1189: Ansible 2.8 support: remove all warnings found in role
15. CCC-1234: Updated min Ansible version and team info
16. CCC-1069: Update to support CIS benchmark v1.4.0
17. CCC-1248: Include ansible-setup role

__Release Tag 0.2.0 - 26-February-2019:__

1. CCC-609: improved default values for kubespray, better support for clusters with multiple master nodes
2. CCC-689: kubeadm support
3. CCC-768: Added Jenkinsfile.manifest file for automation.
4. CCC-787: Logic to add missing flags for kubeadm
5. CCC-788: Updates for version 1.3.0 of the CIS benchmark
6. CCC-788 (bug fix): Added check for RotateKubeletServerCertificate
7. CCC-934: Specify permissions when writing files
8. CCC-968: Ability to add firewall rules
9. CCC-975: Update for Jenkins migration

__Release Tag 0.1.0 - 08-August-2018:__

1. CCC-378: K8s master hardening - API server
2. CCC-379: K8s master hardening - scheduler
3. CCC-380: K8s master hardening - controller manager
4. CCC-381: K8s master hardening - configuration
5. CCC-382: K8s master hardening - etcd
6. CCC-468: K8s master hardening - etcd - Hotfix for CCC-382
7. CCC-384: K8s worker hardening - kubelet
8. CCC-385: K8s worker hardening - configuration files
9. CCC-499: Change default log max age to 6 months
10. CCC-520: Changes to address impact of hardening
11. CCC-528: Maglev default values and support for multiple defaults
12. CCC-574: Changes for Maglev 1.2.0.2087
13. CCC-588: Change include_tasks to import_tasks
