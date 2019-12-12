'use strict';
'require ui';
'require uci';
'require form';
'require network';
'require firewall';
'require tools.prng as random';

var protocols = [
	'ip', 0, 'IP',
	'hopopt', 0, 'HOPOPT',
	'icmp', 1, 'ICMP',
	'igmp', 2, 'IGMP',
	'ggp', 3 , 'GGP',
	'ipencap', 4, 'IP-ENCAP',
	'st', 5, 'ST',
	'tcp', 6, 'TCP',
	'egp', 8, 'EGP',
	'igp', 9, 'IGP',
	'pup', 12, 'PUP',
	'udp', 17, 'UDP',
	'hmp', 20, 'HMP',
	'xns-idp', 22, 'XNS-IDP',
	'rdp', 27, 'RDP',
	'iso-tp4', 29, 'ISO-TP4',
	'dccp', 33, 'DCCP',
	'xtp', 36, 'XTP',
	'ddp', 37, 'DDP',
	'idpr-cmtp', 38, 'IDPR-CMTP',
	'ipv6', 41, 'IPv6',
	'ipv6-route', 43, 'IPv6-Route',
	'ipv6-frag', 44, 'IPv6-Frag',
	'idrp', 45, 'IDRP',
	'rsvp', 46, 'RSVP',
	'gre', 47, 'GRE',
	'esp', 50, 'IPSEC-ESP',
	'ah', 51, 'IPSEC-AH',
	'skip', 57, 'SKIP',
	'ipv6-icmp', 58, 'IPv6-ICMP',
	'ipv6-nonxt', 59, 'IPv6-NoNxt',
	'ipv6-opts', 60, 'IPv6-Opts',
	'rspf', 73, 'RSPF', 'CPHB',
	'vmtp', 81, 'VMTP',
	'eigrp', 88, 'EIGRP',
	'ospf', 89, 'OSPFIGP',
	'ax.25', 93, 'AX.25',
	'ipip', 94, 'IPIP',
	'etherip', 97, 'ETHERIP',
	'encap', 98, 'ENCAP',
	'pim', 103, 'PIM',
	'ipcomp', 108, 'IPCOMP',
	'vrrp', 112, 'VRRP',
	'l2tp', 115, 'L2TP',
	'isis', 124, 'ISIS',
	'sctp', 132, 'SCTP',
	'fc', 133, 'FC',
	'mobility-header', 135, 'Mobility-Header',
	'udplite', 136, 'UDPLite',
	'mpls-in-ip', 137, 'MPLS-in-IP',
	'manet', 138, 'MANET',
	'hip', 139, 'HIP',
	'shim6', 140, 'Shim6',
	'wesp', 141, 'WESP',
	'rohc', 142, 'ROHC',
];

function lookupProto(x) {
	if (x == null || x == '')
		return null;

	var s = String(x).toLowerCase();

	for (var i = 0; i < protocols.length; i += 3)
		if (s == protocols[i] || s == protocols[i+1])
			return [ protocols[i+1], protocols[i+2] ];

	return [ -1, x ];
}


return L.Class.extend({
	fmt_neg: function(x) {
		var rv = E([]),
		    v = (typeof(x) == 'string') ? x.replace(/^ *! */, '') : '';

		L.dom.append(rv, (v != '' && v != x) ? [ _('not') + ' ', v ] : [ '', x ]);
		return rv;
	},

	fmt_mac: function(x) {
		var rv = E([]), l = L.toArray(x);

		if (l.length == 0)
			return null;

		L.dom.append(rv, [ _('MAC') + ' ' ]);

		for (var i = 0; i < l.length; i++) {
			var n = this.fmt_neg(l[i]);
			L.dom.append(rv, (i > 0) ? [ ', ', n ] : n);
		}

		if (rv.childNodes.length > 2)
			rv.firstChild.data = _('MACs') + ' ';

		return rv;
	},

	fmt_port: function(x, d) {
		var rv = E([]), l = L.toArray(x);

		if (l.length == 0) {
			if (d) {
				L.dom.append(rv, E('var', {}, d));
				return rv;
			}

			return null;
		}

		L.dom.append(rv, [ _('port') + ' ' ]);

		for (var i = 0; i < l.length; i++) {
			var n = this.fmt_neg(l[i]),
			    m = n.lastChild.data.match(/^(\d+)\D+(\d+)$/);

			if (i > 0)
				L.dom.append(rv, [ ', ' ]);

			if (m) {
				rv.firstChild.data = _('ports') + ' ';
				L.dom.append(rv, E('var', [ n.firstChild, m[1], '-', m[2] ]));
			}
			else {
				L.dom.append(rv, E('var', {}, n));
			}
		}

		if (rv.childNodes.length > 2)
			rv.firstChild.data = _('ports') + ' ';

		return rv;
	},

	fmt_ip: function(x, d) {
		var rv = E([]), l = L.toArray(x);

		if (l.length == 0) {
			if (d) {
				L.dom.append(rv, E('var', {}, d));
				return rv;
			}

			return null;
		}

		L.dom.append(rv, [ _('IP') + ' ' ]);

		for (var i = 0; i < l.length; i++) {
			var n = this.fmt_neg(l[i]),
			    m = n.lastChild.data.match(/^(\S+)\/(\d+\.\S+)$/);

			if (i > 0)
				L.dom.append(rv, [ ', ' ]);

			if (m)
				rv.firstChild.data = _('IP range') + ' ';
			else if (n.lastChild.data.match(/^[a-zA-Z0-9_]+$/))
				rv.firstChild.data = _('Network') + ' ';

			L.dom.append(rv, E('var', {}, n));
		}

		if (rv.childNodes.length > 2)
			rv.firstChild.data = _('IPs') + ' ';

		return rv;
	},

	fmt_zone: function(x, d) {
		if (x == '*')
			return E('var', _('any zone'));
		else if (x != null && x != '')
			return E('var', {}, [ x ]);
		else if (d != null && d != '')
			return E('var', {}, d);
		else
			return null;
	},

	fmt_icmp_type: function(x) {
		var rv = E([]), l = L.toArray(x);

		if (l.length == 0)
			return null;

		L.dom.append(rv, [ _('type') + ' ' ]);

		for (var i = 0; i < l.length; i++) {
			var n = this.fmt_neg(l[i]);

			if (i > 0)
				L.dom.append(rv, [ ', ' ]);

			L.dom.append(rv, E('var', {}, n));
		}

		if (rv.childNodes.length > 2)
			rv.firstChild.data = _('types') + ' ';

		return rv;
	},

	fmt_family: function(family) {
		if (family == 'ipv4')
			return _('IPv4');
		else if (family == 'ipv6')
			return _('IPv6');
		else
			return _('IPv4 and IPv6');
	},

	fmt_proto: function(x, icmp_types) {
		var rv = E([]), l = L.toArray(x);

		if (l.length == 0)
			return null;

		var t = this.fmt_icmp_type(icmp_types);

		for (var i = 0; i < l.length; i++) {
			var n = this.fmt_neg(l[i]),
			    p = lookupProto(n.lastChild.data);

			if (n.lastChild.data == 'all')
				continue;

			if (i > 0)
				L.dom.append(rv, [ ', ' ]);

			if (t && (p[0] == 1 || p[0] == 58))
				L.dom.append(rv, [ _('%s%s with %s').format(n.firstChild.data, p[1], ''), t ]);
			else
				L.dom.append(rv, [ n.firstChild.data, p[1] ]);
		}

		return rv;
	},

	fmt_limit: function(limit, burst) {
		if (limit == null || limit == '')
			return null;

		var m = String(limit).match(/^(\d+)\/(\w+)$/),
		    u = m[2] || 'second',
		    l = +(m[1] || limit),
		    b = +burst;

		if (!isNaN(l)) {
			if (u.match(/^s/))
				u = _('second');
			else if (u.match(/^m/))
				u = _('minute');
			else if (u.match(/^h/))
				u = _('hour');
			else if (u.match(/^d/))
				u = _('day');

			if (!isNaN(b) && b > 0)
				return E('<span>' +
					_('<var>%d</var> pkts. per <var>%s</var>, burst <var>%d</var> pkts.').format(l, u, b) +
				'</span>');
			else
				return E('<span>' +
					_('<var>%d</var> pkts. per <var>%s</var>').format(l, u) +
				'</span>');
		}
	},

	fmt_target: function(x, src, dest) {
		if (src == null || src == '') {
			if (x == 'ACCEPT')
				return _('Accept output');
			else if (x == 'REJECT')
				return _('Refuse output');
			else if (x == 'NOTRACK')
				return _('Do not track output');
			else /* if (x == 'DROP') */
				return _('Discard output');
		}
		else if (dest != null && dest != '') {
			if (x == 'ACCEPT')
				return _('Accept forward');
			else if (x == 'REJECT')
				return _('Refuse forward');
			else if (x == 'NOTRACK')
				return _('Do not track forward');
			else /* if (x == 'DROP') */
				return _('Discard forward');
		}
		else {
			if (x == 'ACCEPT')
				return _('Accept input');
			else if (x == 'REJECT' )
				return _('Refuse input');
			else if (x == 'NOTRACK')
				return _('Do not track input');
			else /* if (x == 'DROP') */
				return _('Discard input');
		}
	}
});
