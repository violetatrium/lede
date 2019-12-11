local readmeURL = "https://github.com/openwrt/packages/blob/master/net/vpnbypass/files/README.md"
local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"
local util = require "luci.util"
local packageName = "vpnbypass"

local tmpfsVersion = tostring(util.trim(sys.exec("opkg list-installed " .. packageName .. " | awk '{print $3}'")))
if not tmpfsVersion or tmpfsVersion == "" then
  tmpfsStatusCode = -1
  tmpfsVersion = ""
  tmpfsStatus = packageName .. " " .. translate("is not installed or not found")
else  
  tmpfsVersion = " [" .. packageName .. " " .. tmpfsVersion .. "]"
end
local tmpfsStatus = "Stopped"
if sys.call("iptables -t mangle -L | grep -q VPNBYPASS") == 0 then
	tmpfsStatus = "Running"
end

m = Map("vpnbypass", translate("VPN Bypass Settings"))

h = m:section(NamedSection, "config", packageName, translate("Service Status") .. tmpfsVersion)
ss = h:option(DummyValue, "_dummy", translate("Service Status"))
ss.template = packageName .. "/status"
ss.value = tmpfsStatus
buttons = h:option(DummyValue, "_dummy")
buttons.template = packageName .. "/buttons"

s = m:section(NamedSection, "config", "vpnbypass", translate("VPN Bypass Rules"))
-- Local Ports
p1 = s:option(DynamicList, "localport", translate("Local Ports to Bypass"), translate("Local ports to trigger VPN Bypass"))
p1.datatype    = "portrange"
-- p1.placeholder = "0-65535"
p1.addremove = false
p1.optional = false

-- Remote Ports
p2 = s:option(DynamicList, "remoteport", translate("Remote Ports to Bypass"), translate("Remote ports to trigger VPN Bypass"))
p2.datatype    = "portrange"
-- p2.placeholder = "0-65535"
p2.addremove = false
p2.optional = false

-- Local Subnets
r1 = s:option(DynamicList, "localsubnet", translate("Local IP Addresses to Bypass"), translate("Local IP addresses or subnets with direct internet access (outside of the VPN tunnel)"))
r1.datatype    = "ip4addr"
-- r1.placeholder = ip.new(m.uci:get("network", "lan", "ipaddr"), m.uci:get("network", "lan", "netmask"))
r1.addremove = false
r1.optional = false

-- Remote Subnets
r2 = s:option(DynamicList, "remotesubnet", translate("Remote IP Addresses to Bypass"), translate("Remote IP addresses or subnets which will be accessed directly (outside of the VPN tunnel)"))
r2.datatype    = "ip4addr"
-- r2.placeholder = "0.0.0.0/0"
r2.addremove = false
r2.optional = false

-- Domains
d = Map("dhcp")
s4 = d:section(TypedSection, "dnsmasq")
s4.anonymous = true
di = s4:option(DynamicList, "ipset", translate("Domains to Bypass"),
    translate("Domains to be accessed directly (outside of the VPN tunnel), see ")
		.. [[<a href="]] .. readmeURL .. [[#bypass-domains-formatsyntax" target="_blank">]]
    .. translate("README") .. [[</a> ]] .. translate("for syntax"))
function d.on_after_commit(map)
	util.exec("/etc/init.d/dnsmasq restart >/dev/null 2>&1")
end

return m, d
