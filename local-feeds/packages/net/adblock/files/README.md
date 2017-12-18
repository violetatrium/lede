# dns based ad/abuse domain blocking

## Description
A lot of people already use adblocker plugins within their desktop browsers, but what if you are using your (smart) phone, tablet, watch or any other wlan gadget...getting rid of annoying ads, trackers and other abuse sites (like facebook ;-) is simple: block them with your router. When the dns server on your router receives dns requests, you will sort out queries that ask for the resource records of ad servers and return a simple 'NXDOMAIN'. This is nothing but **N**on-e**X**istent Internet or Intranet domain name, if domain name is unable to resolved using the dns server, a condition called the 'NXDOMAIN' occurred.  

## Main Features
* support of the following domain blocklist sources (free for private usage, for commercial use please check their individual licenses):
    * [adaway](https://adaway.org)
    * => infrequent updates, approx. 400 entries (enabled by default)
    * [adguard](https://adguard.com)
    * => numerous updates on the same day, approx. 12.000 entries
    * [bitcoin](https://github.com/hoshsadiq/adblock-nocoin-list)
    * => infrequent updates, approx. 15 entries
    * [blacklist]()
    * => static local blacklist, located by default in '/etc/adblock/adblock.blacklist'
    * [disconnect](https://disconnect.me)
    * => numerous updates on the same day, approx. 6.500 entries (enabled by default)
    * [dshield](http://dshield.org)
    * => daily updates, approx. 4.500 entries
    * [feodotracker](https://feodotracker.abuse.ch)
    * => daily updates, approx. 0-10 entries
    * [hphosts](https://hosts-file.net)
    * => monthly updates, approx. 50.000 entries
    * [malwaredomains](http://malwaredomains.com)
    * => daily updates, approx. 16.000 entries
    * [malwaredomainlist](http://www.malwaredomainlist.com)
    * => daily updates, approx. 1.500 entries
    * [openphish](https://openphish.com)
    * => numerous updates on the same day, approx. 1.800 entries
    * [ransomware tracker](https://ransomwaretracker.abuse.ch)
    * => daily updates, approx. 150 entries
    * [reg_cn](https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt)
    * => regional blocklist for China, daily updates, approx. 1.600 entries
    * [reg_de](https://easylist-downloads.adblockplus.org/easylistgermany+easylist.txt)
    * => regional blocklist for Germany, daily updates, approx. 9.200 entries
    * [reg_id](https://easylist-downloads.adblockplus.org/abpindo+easylist.txt)
    * => regional blocklist for Indonesia, daily updates, approx. 800 entries
    * [reg_nl](https://easylist-downloads.adblockplus.org/easylistdutch+easylist.txt)
    * => regional blocklist for the Netherlands, weekly updates, approx. 1300 entries
    * [reg_pl](http://adblocklist.org)
    * => regional blocklist for Poland, daily updates, approx. 50 entries
    * [reg_ro](https://easylist-downloads.adblockplus.org/rolist+easylist.txt)
    * => regional blocklist for Romania, weekly updates, approx. 600 entries
    * [reg_ru](https://code.google.com/p/ruadlist)
    * => regional blocklist for Russia, weekly updates, approx. 2.000 entries
    * [securemecca](http://www.securemecca.com)
    * => infrequent updates, approx. 25.000 entries
    * [shallalist](http://www.shallalist.de) (categories "adv" "costtraps" "spyware" "tracker" "warez" enabled by default)
    * => daily updates, approx. 32.000 entries (a short description of all shallalist categories can be found [online](http://www.shallalist.de/categories.html))
    * [spam404](http://www.spam404.com)
    * => infrequent updates, approx. 5.000 entries
    * [sysctl/cameleon](http://sysctl.org/cameleon)
    * => weekly updates, approx. 21.000 entries
    * [whocares](http://someonewhocares.org)
    * => weekly updates, approx. 12.000 entries
    * [winhelp](http://winhelp2002.mvps.org)
    * => infrequent updates, approx. 15.000 entries
    * [winspy](https://github.com/crazy-max/WindowsSpyBlocker)
    * => infrequent updates, approx. 120 entries
    * [yoyo](http://pgl.yoyo.org/adservers)
    * => weekly updates, approx. 2.500 entries (enabled by default)
    * [zeus tracker](https://zeustracker.abuse.ch)
    * => daily updates, approx. 440 entries
* zero-conf like automatic installation & setup, usually no manual changes needed
* simple but yet powerful adblock engine: adblock does not use error prone external iptables rulesets, http pixel server instances and things like that
* supports five different dns backends / blocklist formats: dnsmasq, unbound, named (bind), kresd and dnscrypt-proxy
* automatically selects uclient-fetch or wget as download utility (other tools like curl or aria2c are supported as well)
* provides 'http only' mode without installed ssl library for all non-SSL blocklist sources
* supports a wide range of router modes, even AP modes are supported
* full IPv4 and IPv6 support
* provides top level domain compression ('tld compression'), this feature removes thousands of needless host entries from the blocklist and lowers the memory footprint for the dns backends
* blocklist source parsing by fast & flexible regex rulesets
* overall duplicate removal in central blocklist 'adb_list.overall'
* additional whitelist for manual overrides, located by default in /etc/adblock/adblock.whitelist
* quality checks during blocklist update to ensure a reliable dns backend service
* minimal status & error logging to syslog, enable debug logging to receive more output
* procd based init system support (start/stop/restart/reload/suspend/resume/query/status)
* procd network interface trigger support or classic time based startup
* conditional dns backend restarts by old/new blocklist comparison with sha256sum (default) or md5sum
* suspend & resume adblock actions temporarily without blocklist reloading
* output comprehensive runtime information via LuCI or via 'status' init command
* query function to quickly identify blocked (sub-)domains, e.g. for whitelisting
* strong LuCI support
* optional: force dns requests to local resolver
* optional: force overall sort / duplicate removal for low memory devices (handle with care!)
* optional: automatic blocklist backup & restore, they will be used in case of download errors or during startup in backup mode
* optional: 'backup mode' to re-use blocklist backups during startup, get fresh lists only via reload or restart action
* optional: 'whitelist mode' to block access to all domains except those explicitly listed in the whitelist file
* optional: add new adblock sources on your own via uci config

## Prerequisites
* [LEDE project](https://www.lede-project.org), tested with latest stable release (LEDE 17.01) and with current LEDE snapshot
* a usual setup with an enabled dns backend at minimum - dump AP modes without a working dns backend are _not_ supported
* a download utility:
    * to support all blocklist sources a full version (with ssl support) of 'wget', 'uclient-fetch' with one of the 'libustream-*' ssl libraries, 'aria2c' or 'curl' is required
    * for limited devices with real memory constraints, adblock provides also a 'http only' option and supports wget-nossl and uclient-fetch (without libustream-ssl) as well
    * for more configuration options see examples below

## Installation & Usage
* install 'adblock' (_opkg install adblock_)
* at minimum configure the appropriate dns backend ('dnsmasq' by default) and enable the adblock service in _/etc/config/adblock_
* control the adblock service manually with _/etc/init.d/adblock_ start/stop/restart/reload/suspend/resume/status or use the LuCI frontend

## LuCI adblock companion package
* for easy management of the various blocklist sources and all other adblock options you should use the provided LuCI frontend
* install 'luci-app-adblock' (_opkg install luci-app-adblock_)
* the application is located in LuCI under 'Services' menu

## Tweaks
* **runtime information:** the adblock status is available via _/etc/init.d/adblock status_ (see example below)
* **debug logging:** for script debugging please set the config option 'adb\_debug' to '1' and check the runtime output with _logread -e "adblock"_
* **storage expansion:** to process and store all blocklist sources at once it might helpful to enlarge your temp directory with a swap partition => see [openwrt wiki](https://wiki.openwrt.org/doc/uci/fstab) for further details
* **add white- / blacklist entries:** add domain white- or blacklist entries to always-allow or -deny certain (sub) domains, by default both lists are empty and located in _/etc/adblock_. Please add one domain per line - ip addresses, wildcards & regex are _not_ allowed (see example below)
* **backup & restore blocklists:** enable this feature, to restore automatically the latest compressed backup of your blocklists in case of any processing error (e.g. a single blocklist source is not available during update). Please use an (external) solid partition and _not_ your volatile router temp directory for this
* **scheduled list updates:** for a scheduled call of the adblock service add an appropriate crontab entry (see example below)
* **change startup behaviour:** by default the startup will be triggered by the 'wan' procd interface trigger. Choose 'none' to disable automatic startups, 'timed' to use a classic timeout (default 30 sec.) or select another trigger interface.
* **suspend & resume adblocking:** to quickly switch the adblock service 'on' or 'off', simply use _/etc/init.d/adblock [suspend|resume]_
* **domain query:** to query the active blocklist for a specific domain, please run _/etc/init.d/adblock query `<DOMAIN>`_ (see example below)
* **add new list sources:** you could add new blocklist sources on your own via uci config, all you need is a source url and an awk one-liner (see example below)
* **disable active dns probing in windows 10:** to prevent a yellow exclamation mark on your internet connection icon (which wrongly means connected, but no internet), please change the following registry key/value from "1" to "0" _HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet\EnableActiveProbing_

## Further adblock config options
* usually the pre-configured adblock setup works quite well and no manual config overrides are needed, all listed options apply to the 'global' config section:
    * adb\_enabled => main switch to enable/disable adblock service (default: '0', disabled)
    * adb\_debug => enable/disable adblock debug output (default: '0', disabled)
    * adb\_dns => select the dns backend for your environment: 'dnsmasq', 'unbound', 'named', 'kresd' or 'dnscrypt-proxy' (default: 'dnsmasq')
    * adb\_dnsdir => target directory for the generated blocklist 'adb_list.overall' (default: not set, use dns backend default)
    * adb\_trigger => set the startup trigger to a certain interface, to 'timed' or to 'none' (default: 'wan')
    * adb\_triggerdelay => additional trigger delay in seconds before adblock processing begins (default: '1')
    * adb\_fetch => full path to a dedicated download utility, see example below (default: not set, use wget default)
    * adb\_fetchparm => options for the download utility, see example below (default: not set, use wget default options)
    * adb\_forcedns => force dns requests to local resolver (default: '0', disabled)
    * adb\_forcesrt => force overall sort on low memory devices with less than 64 MB RAM (default: '0', disabled)
    * adb\_backup_mode => do not automatically update blocklists during startup, use backups instead (default: '0', disabled)
    * adb\_whitelist_mode => block access to all domains except those explicitly listed in the whitelist file (default: '0', disabled)

## Examples
**change default dns backend to 'unbound':**  

Adblock deposits the final blocklist 'adb_list.overall' in '/var/lib/unbound' where unbound can find them in its jail. If you use manual configuration for unbound, then just include the following line in your 'server' clause:
<pre><code>
  include: "/var/lib/unbound/adb_list.overall"
</code></pre>
  
**change default dns backend to 'named' (bind):**  

Adblock deposits the final blocklist 'adb_list.overall' in '/var/lib/bind'. To use the blocklist please modify '/etc/bind/named.conf':
<pre><code>
in the 'options' namespace add:
  response-policy { zone "rpz"; };

and at the end of the file add:
  zone "rpz" {
    type master;
    file "/var/lib/bind/adb_list.overall";
    allow-query { none; };
    allow-transfer { none; };
  };
</code></pre>
  
**change default dns backend to 'kresd':**  

The knot-resolver (kresd) is only available on turris omnia devices. Adblock deposits the final blocklist 'adb_list.overall' in '/etc/kresd'. To use the blocklist please modify '/etc/config/resolver':
<pre><code>
    list rpz_file '/etc/kresd/adb_list.overall'
</code></pre>
  
**change default dns backend to 'dnscrypt-proxy':**  

The required 'blacklist' option of dnscrypt-proxy is not enabled by default, because the package will be compiled without plugins support. Take a custom LEDE build with plugins support to use this feature. Adblock deposits the final blocklist 'adb_list.overall' in '/tmp'. To use the blocklist please modify '/etc/config/dnscrypt-proxy' per instance:
<pre><code>
  list blacklist 'domains:/tmp/adb_list.overall'
</code></pre>
  
**configuration for different download utilities:**
<pre><code>
wget (default):
  option adb_fetch '/usr/bin/wget'
  option adb_fetchparm '--quiet --no-cache --no-cookies --max-redirect=0 --timeout=10 --no-check-certificate -O'

aria2c:
  option adb_fetch '/usr/bin/aria2c'
  option adb_fetchparm '-q --timeout=10 --allow-overwrite=true --auto-file-renaming=false --check-certificate=false -o'

uclient-fetch:
  option adb_fetch '/bin/uclient-fetch'
  option adb_fetchparm '-q --timeout=10 --no-check-certificate -O'

curl:
  option adb_fetch '/usr/bin/curl'
  option adb_fetchparm '-s --connect-timeout 10 --insecure -o'
</code></pre>
  
**receive adblock runtime information:**
<pre><code>
/etc/init.d/adblock status
::: adblock runtime information
  + adblock_status  : enabled
  + adblock_version : 3.1.0
  + overall_domains : 5117
  + fetch_utility   : wget (built-in)
  + dns_backend     : kresd (/etc/kresd)
  + last_rundate    : 03.11.2017 22:57:41
  + system_release  : Turris Omnia, OpenWrt omnia 15.05/3.8.4
</code></pre>
  
**cronjob for a regular block list update (/etc/crontabs/root):**
<pre><code>
0 06 * * *    /etc/init.d/adblock reload
</code></pre>
  
**blacklist entry (/etc/adblock/adblock.blacklist):**
<pre><code>
ads.example.com

This entry blocks the following (sub)domains:
  http://ads.example.com/foo.gif
  http://server1.ads.example.com/foo.gif
  https://ads.example.com:8000/

This entry does not block:
  http://ads.example.com.ua/foo.gif
  http://example.com/
</code></pre>
  
**whitelist entry (/etc/adblock/adblock.whitelist):**
<pre><code>
here.com

This entry removes the following (sub)domains from the blocklist:
  maps.here.com
  here.com

This entry does not remove:
  where.com
  www.adwhere.com
</code></pre>
  
**query the active blocklist for a certain (sub-)domain, e.g. for whitelisting:**  

The query function checks against the submitted (sub-)domain and recurses automatically to the upper top level domain. For every (sub-)domain it returns the first ten relevant results.
<pre><code>
/etc/init.d/adblock query www.example.google.com
::: max. ten results for domain 'www.example.google.com'
  - no match
::: max. ten results for domain 'example.google.com'
  - no match
::: max. ten results for domain 'google.com'
  + analytics.google.com
  + googleadapis.l.google.com
  + pagead.l.google.com
  + partnerad.l.google.com
  + ssl-google-analytics.l.google.com
  + video-stats.video.google.com
  + www-google-analytics.l.google.com
</code></pre>
  
**add a new blocklist source:**  

1. the easy way ...  
example: https://easylist-downloads.adblockplus.org/rolist+easylist.txt  
Adblock already supports an easylist source, called 'reg_ru'. To add the additional local easylist as a new source, copy the existing config source section and change only
the source name, the url and the description - that's all!
<pre><code>
config source 'reg_ro'
  option enabled '0'
  option adb_src 'https://easylist-downloads.adblockplus.org/rolist+easylist.txt'
  option adb_src_rset 'BEGIN{FS=\"[|^]\"}\$0~/^\|\|([[:alnum:]_-]+\.){1,}[[:alpha:]]+\^("\\\$third-party")?$/{print tolower(\$3)}'
  option adb_src_desc 'focus on romanian ads plus generic easylist additions, weekly updates, approx. 9.400 entries'
</code></pre>

2. a bit harder ...  
To add a really new source with different domain/host format you have to write a suitable awk one-liner on your own, so basic awk skills are needed. As a starting point check the already existing awk rulesets 'adb_src_rset' in the config file, probably you need only small changes for your individual list. Download the desired list and test your new awk string locally. The output result should be a sequential list with one domain/host per line - nothing more. If your awk one-liner works quite well, add a new source section to the adblock config file and test the new source.  

## Support
Please join the adblock discussion in this [forum thread](https://forum.lede-project.org/t/adblock-2-x-support-thread/507) or contact me by mail <dev@brenken.org>  

## Removal
* stop all adblock related services with _/etc/init.d/adblock stop_
* optional: remove the adblock package (_opkg remove adblock_)

Have fun!  
Dirk  
