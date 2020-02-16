## Playbook for AccessHub configuration on CentOS/Redhat above v6.
* Creation of user accesshubid with no password. Login through public key & have sudoers acces.
* Installation & Configuration of 1FA v6.4 (Single factor authentication).
* Installation & Configuration of 2FA v1.11.1 (Two factor authentication).
  * Before 1FA configured

```console
Ankurs-MBP:~ ankugaik$ ssh isadmin@9.45.124.180
isadmin@9.45.124.180's password:
Last login: Mon Oct 29 08:00:06 2018 from 9.102.1.48
IBM's internal systems must only be used for conducting IBM's business or for purposes authorized by IBM management
[isadmin@test999 ~]$ sudo su -
[sudo] password for isadmin:
Last login: Mon Oct  8 10:46:35 EDT 2018 on tty1
[root@test999 ~]# id accesshubid
id: accesshubid: no such user
[root@test999 ~]#
```

#### Full Play

* This will create -
  * This will create only accesshubid with sudoers access & login through public key.
  * Install & configure 1FA & 2FA in server.
    * Note - After successful play, Server registration details for 2FA should be added manually in file **/etc/duo/pam_duo.conf** in each server.

* Execution
```
ansible-playbook -i hosts.inv -bkK -l tmp accesshubmain.yaml
```

* Example
```console
root@dpev001:/opt/ansible/Accesshub2FA# ansible-playbook -i hosts.inv -bkK -l tmp accesshubmain.yaml
SSH password:
SUDO password[defaults to SSH password]:

PLAY [all] *************************************************************************************************************************************************************************************************

TASK [Install python] **************************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Gathering facts] *************************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Create user 'accesshubid'] ***************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Allow 'accesshubid' user to have sudo access] ********************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Create .ssh directory for accesshubid] ***************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Add authorized_keys for accesshubid] *****************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Enable key based authentication] *********************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy 1FA packages & configs to server] ***************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Install 1FA packages] ********************************************************************************************************************************************************************************
changed: [9.45.124.70] => (item=idsldap-clt64bit64-6.4.0-0.x86_64.rpm)
changed: [9.45.124.70] => (item=gskcrypt64-8.0.14.26.linux.x86_64.rpm)
changed: [9.45.124.70] => (item=gskssl64-8.0.14.26.linux.x86_64.rpm)
changed: [9.45.124.70] => (item=idsldap-cltbase64-6.4.0-0.x86_64.rpm)
 [WARNING]: Consider using the yum, dnf or zypper module rather than running rpm.  If you need to use command because yum, dnf or zypper is insufficient you can add warn=False to this command task or set
command_warnings=False in ansible.cfg to get rid of this message.


TASK [Configure LDAP Client library in server load path] ***************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Dynamically load libraries] **************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy pam_1fa.so] *************************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Enable ChallengeResponseAuthentication] **************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Restart sshd Service] ********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Configure /etc/pam.d/sshd] ***************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Configure /etc/pam.d/sudo] ***************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy pam_1fa.conf] ***********************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy existing ED certificate] ************************************************************************************************************************************************************************
changed: [9.45.124.70] => (item={u'src': u'ldapkey.kdb', u'dst': u'ldapkey.kdb.orig'})
changed: [9.45.124.70] => (item={u'src': u'ldapkey.sth', u'dst': u'ldapkey.sth.orig'})

TASK [Upgrade ED certificate] ******************************************************************************************************************************************************************************
ok: [9.45.124.70] => (item={u'src': u'ldapkey.kdb', u'dst': u'ldapkey.kdb'})
ok: [9.45.124.70] => (item={u'src': u'ldapkey.sth', u'dst': u'ldapkey.sth'})

TASK [Disable "Selinux"] ***********************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy 2FA packages & configs to server] ***************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Extract 2FA package] *********************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Install OpenSSL and PAM pre-requisites] **************************************************************************************************************************************************************
ok: [9.45.124.70] => (item={u'name': u'openssl-devel'})
ok: [9.45.124.70] => (item={u'name': u'pam-devel'})
ok: [9.45.124.70] => (item={u'name': u'gcc'})

TASK [Install 2FA packages] ********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy pam_duo.conf] ***********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Modify /etc/ssh/sshd_config] *************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy PAM config for 2FA] *****************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Restart sshd Service] ********************************************************************************************************************************************************************************
changed: [9.45.124.70]

PLAY RECAP *************************************************************************************************************************************************************************************************
9.45.124.70                : ok=28   changed=14   unreachable=0    failed=0
```

#### Accesshubid creation Play

* This will create only accesshubid with sudoers access & login through public key.

* Execution with using tag.
```
ansible-playbook -i hosts.inv -bkK -l tmp -t accesshubid accesshubmain.yaml
```

* Example
```console
root@dpev001:/opt/ansible/Accesshub# ansible-playbook -i hosts.inv -bkK -l tmp1 -t accesshubid accesshubmain.yaml
SSH password:
SUDO password[defaults to SSH password]:

PLAY [all] *************************************************************************************************************************************************************************************************

TASK [Install python] **************************************************************************************************************************************************************************************
changed: [9.45.124.180]

TASK [Gathering facts] *************************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Create user 'accesshubid'] ***************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Allow 'accesshubid' user to have sudo access] ********************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Create .ssh directory for accesshubid] ***************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Add authorized_keys for accesshubid] *****************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Enable key based authentication] *********************************************************************************************************************************************************************
ok: [9.45.124.180]

PLAY RECAP *************************************************************************************************************************************************************************************************
9.45.124.180               : ok=7    changed=1    unreachable=0    failed=0
```

#### 1FA installation & configuration play.

* This will install & configure 1FA in server.
  * Execution with using tag.
```
ansible-playbook -i hosts.inv -bkK -l tmp -t 1FA accesshubmain.yaml
```

* Example
```console
root@dpev001:/opt/ansible/Accesshub# ansible-playbook -i hosts.inv -bkK -l tmp1 -t 1FA accesshubmain.yaml
SSH password:
SUDO password[defaults to SSH password]:

PLAY [all] *************************************************************************************************************************************************************************************************

TASK [Install python] **************************************************************************************************************************************************************************************
changed: [9.45.124.180]

TASK [Gathering facts] *************************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Copy 1F packages & configs to server] ****************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Install 1FA packages] ********************************************************************************************************************************************************************************
changed: [9.45.124.180] => (item=idsldap-clt64bit64-6.4.0-0.x86_64.rpm)
changed: [9.45.124.180] => (item=gskcrypt64-8.0.14.26.linux.x86_64.rpm)
changed: [9.45.124.180] => (item=gskssl64-8.0.14.26.linux.x86_64.rpm)
changed: [9.45.124.180] => (item=idsldap-cltbase64-6.4.0-0.x86_64.rpm)
 [WARNING]: Consider using the yum, dnf or zypper module rather than running rpm.  If you need to use command because yum, dnf or zypper is insufficient you can add warn=False to this command task or set
command_warnings=False in ansible.cfg to get rid of this message.


TASK [Configure LDAP Client library in server load path] ***************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Dynamically load libraries] **************************************************************************************************************************************************************************
changed: [9.45.124.180]

TASK [Copy pam_1fa.so] *************************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Enable ChallengeResponseAuthentication] **************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Restart sshd Service] ********************************************************************************************************************************************************************************
changed: [9.45.124.180]

TASK [Configure /etc/pam.d/sshd] ***************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Configure /etc/pam.d/sudo] ***************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Copy pam_1fa.conf] ***********************************************************************************************************************************************************************************
ok: [9.45.124.180]

TASK [Copy existing ED certificate] ************************************************************************************************************************************************************************
changed: [9.45.124.180] => (item={u'src': u'ldapkey.kdb', u'dst': u'ldapkey.kdb.orig'})
changed: [9.45.124.180] => (item={u'src': u'ldapkey.sth', u'dst': u'ldapkey.sth.orig'})

TASK [Upgrade ED certificate] ******************************************************************************************************************************************************************************
ok: [9.45.124.180] => (item={u'src': u'ldapkey.kdb', u'dst': u'ldapkey.kdb'})
ok: [9.45.124.180] => (item={u'src': u'ldapkey.sth', u'dst': u'ldapkey.sth'})

TASK [Disable "Selinux"] ***********************************************************************************************************************************************************************************
ok: [9.45.124.180]

PLAY RECAP *************************************************************************************************************************************************************************************************
9.45.124.180               : ok=15   changed=5    unreachable=0    failed=0
```

#### 2FA installation & configuration play.

* This will install & configure 2FA in server.
* 2FA has dependency over 1FA for ldap config, so this play includes few tasks of 1FA.
  * Execution with using tag.
```
ansible-playbook -i hosts.inv -bkK -l tmp -t 2FA accesshubmain.yaml
```

* Example
```console
root@dpev001:/opt/ansible/Accesshub2FA# ansible-playbook -i hosts.inv -bkK -l tmp -t 2FA accesshubmain.yaml
SSH password:
SUDO password[defaults to SSH password]:

PLAY [all] *************************************************************************************************************************************************************************************************

TASK [Install python] **************************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Gathering facts] *************************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy 1FA packages & configs to server] ***************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Install 1FA packages] ********************************************************************************************************************************************************************************
changed: [9.45.124.70] => (item=idsldap-clt64bit64-6.4.0-0.x86_64.rpm)
changed: [9.45.124.70] => (item=gskcrypt64-8.0.14.26.linux.x86_64.rpm)
changed: [9.45.124.70] => (item=gskssl64-8.0.14.26.linux.x86_64.rpm)
changed: [9.45.124.70] => (item=idsldap-cltbase64-6.4.0-0.x86_64.rpm)
 [WARNING]: Consider using the yum, dnf or zypper module rather than running rpm.  If you need to use command because yum, dnf or zypper is insufficient you can add warn=False to this command task or set
command_warnings=False in ansible.cfg to get rid of this message.


TASK [Configure LDAP Client library in server load path] ***************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Dynamically load libraries] **************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy pam_1fa.so] *************************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Enable ChallengeResponseAuthentication] **************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Restart sshd Service] ********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Configure /etc/pam.d/sshd] ***************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Configure /etc/pam.d/sudo] ***************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy pam_1fa.conf] ***********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy existing ED certificate] ************************************************************************************************************************************************************************
changed: [9.45.124.70] => (item={u'src': u'ldapkey.kdb', u'dst': u'ldapkey.kdb.orig'})
changed: [9.45.124.70] => (item={u'src': u'ldapkey.sth', u'dst': u'ldapkey.sth.orig'})

TASK [Upgrade ED certificate] ******************************************************************************************************************************************************************************
changed: [9.45.124.70] => (item={u'src': u'ldapkey.kdb', u'dst': u'ldapkey.kdb'})
changed: [9.45.124.70] => (item={u'src': u'ldapkey.sth', u'dst': u'ldapkey.sth'})

TASK [Disable "Selinux"] ***********************************************************************************************************************************************************************************
ok: [9.45.124.70]

TASK [Copy 2FA packages & configs to server] ***************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Extract 2FA package] *********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Install OpenSSL and PAM pre-requisites] **************************************************************************************************************************************************************
ok: [9.45.124.70] => (item={u'name': u'openssl-devel'})
changed: [9.45.124.70] => (item={u'name': u'pam-devel'})
ok: [9.45.124.70] => (item={u'name': u'gcc'})

TASK [Install 2FA packages] ********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy pam_duo.conf] ***********************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Modify /etc/ssh/sshd_config] *************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Copy PAM config for 2FA] *****************************************************************************************************************************************************************************
changed: [9.45.124.70]

TASK [Restart sshd Service] ********************************************************************************************************************************************************************************
changed: [9.45.124.70]

PLAY RECAP *************************************************************************************************************************************************************************************************
9.45.124.70                : ok=23   changed=21   unreachable=0    failed=0
```

* After the successfull play.
```console
Ankurs-MBP:~ ankugaik$ ssh isadmin@9.45.124.180
Please input your local password:
Last login: Mon Oct 29 08:09:43 2018 from dpev001.innovate.ibm.com
IBM's internal systems must only be used for conducting IBM's business or for purposes authorized by IBM management
[isadmin@test999 ~]$ sudo su -
Please input your local password:
Last login: Mon Oct 29 08:01:37 EDT 2018 on pts/0

[root@test999 ~]# id accesshubid
uid=1002(accesshubid) gid=1003(accesshubid) groups=1003(accesshubid)

[root@test999 ~]# cat /home/accesshubid/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjCpZFAfIvTG/kCQzODau6fckrIdSMjx/eII5ZteaQpSPpIW5AKy1QxASRN/VUZ6bwyF5TTv7dyuf+EwN/wzZh6h07l0mUDs+AOuwv4jpO5KFTDIf+HYEwfm3RF7X9tqLi5N3vqtl449OX8TiwRwMOtcMbB9ehLuEkAPjPOZ99d1rnReXaGc1BC9JrEWJS2Dv4BqM+LQJJou1CwvA5RtyufthpiQwHR3U/l31gUfx5LOdkyKS8yD0lVEyn7jBmDA9/VidBf/UONPjc7LEljonWNSme5cw07VyBLhfp433dyz9UvExgkj861g5OgQMvOxWCMsQSeneKXWEZ2bTbxbRl ec2-user@ip-10-0-2-9

[root@test999 ~]# cat /etc/sudoers | grep ACCESSHUBID
%accesshubid	ALL=(ALL)	NOPASSWD: ACCESSHUBID
Cmnd_Alias ACCESSHUBID = /bin/cat, /bin/chmod, /bin/cp, /bin/kill, /bin/ls, /usr/bin/chage, /bin/ed, /usr/bin/ed, /usr/bin/faillog, /usr/bin/groups, /usr/bin/passwd, /usr/bin/tee, /usr/sbin/groupadd, /usr/sbin/groupdel, /usr/sbin/groupmod, /usr/sbin/useradd, /usr/sbin/userdel, /usr/sbin/usermod, /bin/gpasswd

[root@test999 ~]#
```
#### Testing with W3 ID

* User ID creation with GECOS
  * Example
```console
[root@test999 ~]# useradd ankur -c 744/I/07813N//Ankur.Gaikwad/ankugaik@in.ibm.com
```

* Login with w3 id with 1F enabled.
```console
Ankurs-MBP:~ ankugaik$ ssh ankur@9.45.124.180
Please input your w3id password:
IBM's internal systems must only be used for conducting IBM's business or for purposes authorized by IBM management
[ankur@test999 ~]$
```

* Login with w3 id with 2F enabled after registering server in AccessHUb & updated file **/etc/duo/pam_duo.conf**
```console
Ankurs-MBP:~ ankugaik$ ssh ankur@dpev004
Please input your w3id password:
Duo two-factor login for ankugaik@in.ibm.com

Enter a passcode or select one of the following options:

 1. Duo Push to +XX XXXXX X1379
 2. Phone call to +XX XXXXX X1379
 3. SMS passcodes to +XX XXXXX X1379

Passcode or option (1-3): 1
Success. Logging you in...
Last login: Thu Dec  6 02:57:35 2018 from 9.85.71.165
IBM's internal systems must only be used for conducting IBM's business or for purposes authorized by IBM management

[ankur@dpev004 ~]$ sudo su -
Please input your w3id password:
Last login: Thu Dec  6 02:57:43 EST 2018 on pts/1
[root@dpev004 ~]#
```

* Note - As of now, Registering server in AccessHub for 2FA & updating file **/etc/duo/pam_duo.conf** is manual process. This will be automated soon.
