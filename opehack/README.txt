README for OpenHack 2002 download files

This file describes the various file archives eWEEK is providing for use of our readers. All the files were generated as part of our fourth OpenHack security test, which ran from Oct. 22, 2002 to Nov. 8, 2002.

1. IDS and server hardware usage log reports (909 KB).zip

This archive contains reports from attack data collected by the IntruShield 2600 intrusion detection system and hardware usage (CPU, network, memory, and firewall) statistics collected by the symon monitoring program.

2. Microsoft-provided documentation and scripts (57 KB).zip

This archive contains hardening documentation and scripts provided and used by Microsoft for the servers they managed.

3. OpenBSD-based machines install script (4 KB).zip

This archive contains a text file describing how eWEEK set up the OpenBSD-based machines used in the test. These machines were our four firewalls, www.openhack.com Web server, domain name server and mail server.

4. OpenHack 2002 app source code (675 KB).zip

This archive contains the source code for the OpenHack test application in three versions: eWEEK’s original reference application, Microsoft’s version and Oracle’s version. Microsoft’s version is written in ASP .Net and C#. Oracle’s version is written in JavaServer Pages and Java.

5. Oracle-provided documentation and scripts (331 KB).zip

This archive contains hardening documentation and scripts provided and used by Oracle for the servers they managed.

6. README for OpenHack 2002 download files.txt

This file.

7. server backups (including log files) (119 MB).zip

This archive contains contents copied directly from the OpenHack servers.

For the OpenBSD servers, it has contents of the following directories: /root, /etc (files changed from the default install only), /home and /var/log. The www.openhack.com server has the full Apache configuration and raw log files. Things you may want to look at in particular are the /etc/pf.conf file on each server which defines the firewall settings used on each machine. The fw.openhack.com server was our main firewall.

For the Microsoft servers, this file includes saved event logs and raw Web and URLScan log files.

For the Oracle servers, this file contains the Apache configuration and raw Web logs for the Oracle9i Application Server.

We hope you find these files useful.

Timothy Dyck
eWEEK Labs West Coast Technical Director
timothy_dyck@ziffdavis.com
