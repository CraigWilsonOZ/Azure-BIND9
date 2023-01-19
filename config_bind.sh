#!/bin/sh
#set -eu -o pipefail # fail on error and report it, debug all lines

echo "BIND9 install and configuration (Tested on Ubuntu 20.04 LTS)"
echo "Checking for sudo access."
sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo "you have 5 seconds to proceed ..."
echo "or"
echo "hit Ctrl+C to quit"
echo -e "\n"
sleep 6

## Checking if script has recorded a completed flag to stop overwriting configuration
if test -f /etc/bind/.config.done;
then
    echo "Install Done check for file flag exists"
    exit
fi

# Variables
ALLOWEDNETWORK="any;" # Any IP Address
# ALLOWEDNETWORK="192.168.1.0/24;" # Allow query from local network
FORWARDER1="8.8.8.8" # Google DNS Server
FORWARDER2="1.1.1.1" # Cloudflare DNS Server
FORWARDER3="168.63.129.16" # Azure DNS Server
       
echo "[+] Creating BIND9 Configuration"
echo " - Creating backup of bind conf"
sudo cp /etc/bind/named.conf /etc/bind/named.conf.bak
sudo cp /etc/bind/named.conf.default-zones /etc/bind/named.conf.default-zones.bak
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak

echo "[+] Creating BIND Configuration"
echo " - Creating /etc/bind/named.conf"
# Creating Configuration file

sudo cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    forwarders {
        $FORWARDER1;
        $FORWARDER2;
        $FORWARDER3;
    };
    dnssec-validation auto;
    forward only; 
    allow-query { $ALLOWEDNETWORK };    # Allow any query
    # recursion no; 				# disable recursion
    auth-nxdomain no; 		          # disable referral for non-existing domain
    version "Not Disclosed"; 	      # hide version of BIND
};

# Azure Forwarders Global Zones (Non Gov and Non CN)

zone "azure-automation.net" { type forward; forwarders { 168.63.129.16; }; };
zone "database.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "sql.azuresynapse.net" { type forward; forwarders { 168.63.129.16; }; };
zone "sqlondemand.azuresynapse.net" { type forward; forwarders { 168.63.129.16; }; };
zone "dev.azuresynapse.net" { type forward; forwarders { 168.63.129.16; }; };
zone "azuresynapse.net" { type forward; forwarders { 168.63.129.16; }; };
zone "blob.core.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "table.core.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "queue.core.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "file.core.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "web.core.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "dfs.core.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "documents.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "mongo.cosmos.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "cassandra.cosmos.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "gremlin.cosmos.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "table.cosmos.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.batch.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.service.batch.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.batch.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.service.batch.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "postgres.database.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "mysql.database.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "mariadb.database.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "vault.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "vaultcore.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "managedhsm.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.azmk8s.io" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.azmk8s.io" { type forward; forwarders { 168.63.129.16; }; };
zone "search.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "azurecr.io" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.azurecr.io" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.azurecr.io" { type forward; forwarders { 168.63.129.16; }; };
zone "azconfig.io" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.backup.windowsazure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.siterecovery.windowsazure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.backup.windowsazure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.siterecovery.windowsazure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "azure-devices.net" { type forward; forwarders { 168.63.129.16; }; };
zone "azure-devices-provisioning.net" { type forward; forwarders { 168.63.129.16; }; };
zone "servicebus.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "eventgrid.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "azurewebsites.net" { type forward; forwarders { 168.63.129.16; }; };
zone "scm.azurewebsites.net" { type forward; forwarders { 168.63.129.16; }; };
zone "api.azureml.ms " { type forward; forwarders { 168.63.129.16; }; };
zone "notebooks.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "instances.azureml.ms " { type forward; forwarders { 168.63.129.16; }; };
zone "aznbcontent.net" { type forward; forwarders { 168.63.129.16; }; };
zone "service.signalr.net" { type forward; forwarders { 168.63.129.16; }; };
zone "monitor.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "oms.opinsights.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ods.opinsights.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "agentsvc.azure-automation.net" { type forward; forwarders { 168.63.129.16; }; };
zone "applicationinsights.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "cognitiveservices.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.afs.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.afs.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "datafactory.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "adf.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "redis.cache.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "redisenterprise.cache.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "purview.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "digitaltwins.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "azurehdinsight.net" { type forward; forwarders { 168.63.129.16; }; };
zone "his.arc.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "guestconfiguration.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "kubernetesconfiguration.azure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "media.azure.net" { type forward; forwarders { 168.63.129.16; }; };
zone "ae.kusto.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "ase.kusto.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "azurestaticapps.net" { type forward; forwarders { 168.63.129.16; }; };
zone "prod.migration.windowsazure.com" { type forward; forwarders { 168.63.129.16; }; };
zone "azure-api.net" { type forward; forwarders { 168.63.129.16; }; };
zone "developer.azure-api.net" { type forward; forwarders { 168.63.129.16; }; };
zone "analysis.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "pbidedicated.windows.net" { type forward; forwarders { 168.63.129.16; }; };
zone "tip1.powerquery.microsoft.com" { type forward; forwarders { 168.63.129.16; }; };
zone "directline.botframework.com" { type forward; forwarders { 168.63.129.16; }; };
zone "europe.directline.botframework.com" { type forward; forwarders { 168.63.129.16; }; };
zone "token.botframework.com" { type forward; forwarders { 168.63.129.16; }; };
zone "europe.token.botframework.com" { type forward; forwarders { 168.63.129.16; }; };
zone "workspace.azurehealthcareapis.com" { type forward; forwarders { 168.63.129.16; }; };
zone "fhir.azurehealthcareapis.com" { type forward; forwarders { 168.63.129.16; }; };
zone "dicom.azurehealthcareapis.com" { type forward; forwarders { 168.63.129.16; }; };
zone "azuredatabricks.net" { type forward; forwarders { 168.63.129.16; }; };
# zone "{instanceName}.{dnsPrefix}.database.windows.net" { type forward; forwarders { 168.63.129.16; }; };
# zone "{partitionId}.azurestaticapps.net" { type forward; forwarders { 168.63.129.16; }; };

logging {
     channel default_log {
          file "/var/log/bind/default" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel auth_servers_log {
          file "/var/log/bind/auth_servers" versions 100 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel dnssec_log {
          file "/var/log/bind/dnssec" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel zone_transfers_log {
          file "/var/log/bind/zone_transfers" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel ddns_log {
          file "/var/log/bind/ddns" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel client_security_log {
          file "/var/log/bind/client_security" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel rate_limiting_log {
          file "/var/log/bind/rate_limiting" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel rpz_log {
          file "/var/log/bind/rpz" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
     channel dnstap_log {
          file "/var/log/bind/dnstap" versions 3 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
//
// If you have the category 'queries' defined, and you don't want query logging
// by default, make sure you add option 'querylog no;' - then you can toggle
// query logging on (and off again) using command 'rndc querylog'
//
     channel queries_log {
          file "/var/log/bind/queries" versions 600 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity info;
     };
//
// This channel is dynamic so that when the debug level is increased using
// rndc while the server is running, extra information will be logged about
// failing queries.  Other debug information for other categories will be
// sent to the channel default_debug (which is also dynamic), but without
// affecting the regular logging.
//
     channel query-errors_log {
          file "/var/log/bind/query-errors" versions 5 size 20m;
          print-time yes;
          print-category yes;
          print-severity yes;
          severity dynamic;
     };
//
// This is the default syslog channel, defined here for clarity.  You don't
// have to use it if you prefer to log to your own channels.
// It sends to syslog's daemon facility, and sends only logged messages
// of priority info and higher.
// (The options to print time, category and severity are non-default.)
//
     channel default_syslog {
          print-time yes;
          print-category yes;
          print-severity yes;
          syslog daemon;
          severity info;
     };
//
// This is the default debug output channel, defined here for clarity.  You
// might want to redefine the output destination if it doesn't fit with your
// local system administration plans for logging.  It is also a special
// channel that only produces output if the debug level is non-zero.
//
     channel default_debug {
          print-time yes;
          print-category yes;
          print-severity yes;
          file "named.run";
          severity dynamic;
     };
//
// Log routine stuff to syslog and default log:
//
     category default { default_syslog; default_debug; default_log; };
     category config { default_syslog; default_debug; default_log; };
     category dispatch { default_syslog; default_debug; default_log; };
     category network { default_syslog; default_debug; default_log; };
     category general { default_syslog; default_debug; default_log; };
//
// From BIND 9.12 and newer, you can direct zone load logging to another
// channel with the new zoneload logging category.  If this would be useful
// then firstly, configure the new channel, and then edit the line below
// to direct the category there instead of to syslog and default log:
//
     category zoneload { default_syslog; default_debug; default_log; };
//
// Log messages relating to what we got back from authoritative servers during
// recursion (if lame-servers and edns-disabled are obscuring other messages
// they can be sent to their own channel or to null).  Sometimes these log
// messages will be useful to research why some domains don't resolve or
// don't resolve reliably
//
     category resolver { auth_servers_log; default_debug; };       
     category cname { auth_servers_log; default_debug; };       
     category delegation-only { auth_servers_log; default_debug; };
     category lame-servers { auth_servers_log; default_debug; };
     category edns-disabled { auth_servers_log; default_debug; };
//
// Log problems with DNSSEC:
//
     category dnssec { dnssec_log; default_debug; };
//
// Log together all messages relating to authoritative zone propagation
//
     category notify { zone_transfers_log; default_debug; };       
     category xfer-in { zone_transfers_log; default_debug; };       
     category xfer-out { zone_transfers_log; default_debug; };
//
// Log together all messages relating to dynamic updates to DNS zone data:
//
     category update{ ddns_log; default_debug; };
     category update-security { ddns_log; default_debug; };
//
// Log together all messages relating to client access and security.
// (There is an additional category 'unmatched' that is by default sent to
// null but which can be added here if you want more than the one-line
// summary that is logged for failures to match a view).
//
     category client{ client_security_log; default_debug; };       
     category security { client_security_log; default_debug; };
//
// Log together all messages that are likely to be related to rate-limiting.
// This includes RRL (Response Rate Limiting) - usually deployed on authoritative
// servers and fetches-per-server|zone.  Note that it does not include
// logging of changes for clients-per-query (which are logged in category
// resolver).  Also note that there may on occasions be other log messages
// emitted by the database category that don't relate to rate-limiting
// behaviour by named.
//
     category rate-limit { rate_limiting_log; default_debug; };       
     category spill { rate_limiting_log; default_debug; };       
     category database { rate_limiting_log; default_debug; };
//
// Log DNS-RPZ (Response Policy Zone) messages (if you are not using DNS-RPZ
// then you may want to comment out this category and associated channel)
//
     category rpz { rpz_log; default_debug; };
//
// Log messages relating to the "dnstap" DNS traffic capture system  (if you
// are not using dnstap, then you may want to comment out this category and
// associated channel).
//
     category dnstap { dnstap_log; default_debug; };
//
// If you are running a server (for example one of the Internet root
// nameservers) that is providing RFC 5011 trust anchor updates, then you
// may be interested in logging trust anchor telemetry reports that your
// server receives to analyze anchor propagation rates during a key rollover. 
// If this would be useful then firstly, configure the new channel, and then
// un-comment and the line below to direct the category there instead of to
// syslog and default log:
//
//
     category trust-anchor-telemetry { default_syslog; default_debug; default_log; };
//
// If you have the category 'queries' defined, and you don't want query logging
// by default, make sure you add option 'querylog no;' - then you can toggle
// query logging on (and off again) using command 'rndc querylog'
//
     category queries { queries_log; };
//
// This logging category will only emit messages at debug levels of 1 or
// higher - it can be useful to troubleshoot problems where queries are
// resulting in a SERVFAIL response.
//
     category query-errors {query-errors_log; };
};

EOF

echo "[+] Restarting BIND Service"
sudo systemctl stop bind9
sudo systemctl start bind9
sudo systemctl status bind9

echo "[+] Creating file to record completed setup"
echo " - Creating file to flag completed setup"
sudo touch /etc/bind/.config.done

echo "[+] Setup completed"