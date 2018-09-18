**DNS BIND**

Prequsition: 
Already BIND Services installed and Running

SOA - Start of Authority

NS - NAME SERVER - Indntity a DNS Server Domain

A or AAAA - Indiviual host of the domain A - IPv4 or AAAA - IPv6

CNAME - Canonical Name - assign another name alias for host

MX - Mail Exchanger - mail server of the domain

PTR - Pointer - Used for Reverse DNS lookups


**named.conf sample**

````
options {
		directory "/var/named"
};

zone "lanclin.com" {
		type master;
		file "lanclin.com.zone";
		allow-update { none; };
}

zone "0.x.x.50.in-addr.arpa" {
	type master;
	file "0.x.x.50.in-addr.arpa"
}
````
**Zone Files**

**Foward Lookup Zone File**
```

/var/named/lanclin.com.zone
====================

$TTL 86400
@			SOA		lanclin.com.		root (
							2001062501  ; serial
							21600       ; refresh after 6 hours
							3600        ; retry after 1 hour
							604800      ; expire after 1 week
							86400 )     ; minimum TTL of 1 day	

@			NS		jump.lanclin.com.
@			NS		techbox.lanclin.com.
jump		A		50.x.x.115
techbox A		50.x.x.113

```

**Rerverse Lookup Zone File**

```
/var/named/0.x.x.50.in-addr.arpa
===========================

$TTL 	86400
@			IN		root.jump.lanclin.com. (
						2001062501  ; serial
						21600       ; refresh after 6 hours
						3600        ; retry after 1 hour
						604800      ; expire after 1 week
						86400 )     ; minimum TTL of 1 day	

			IN	    NS 		jump.lanclin.com.
115			IN		PTR		jump.lanclin.com.
113			IN		PTR		techbox.lanclin.com.
```

**Verify the named cache - Root Servers**
```
cat /var/named/named.cache

.                       518388  IN      NS      b.root-servers.net.
.                       518388  IN      NS      g.root-servers.net.
.                       518388  IN      NS      i.root-servers.net.
.                       518388  IN      NS      c.root-servers.net.
.                       518388  IN      NS      h.root-servers.net.
.                       518388  IN      NS      e.root-servers.net.
.                       518388  IN      NS      k.root-servers.net.
.                       518388  IN      NS      a.root-servers.net.
.                       518388  IN      NS      d.root-servers.net.
.                       518388  IN      NS      f.root-servers.net.
.                       518388  IN      NS      l.root-servers.net.
.                       518388  IN      NS      m.root-servers.net.
.                       518388  IN      NS      j.root-servers.net.

a.root-servers.net.     604788  IN      A       198.41.0.4
a.root-servers.net.     604788  IN      AAAA    2001:503:ba3e::2:30
b.root-servers.net.     604788  IN      A       192.228.79.201
b.root-servers.net.     604788  IN      AAAA    2001:500:84::b
c.root-servers.net.     604788  IN      A       192.33.4.12
c.root-servers.net.     604788  IN      AAAA    2001:500:2::c
d.root-servers.net.     604788  IN      A       199.7.91.13
d.root-servers.net.     604788  IN      AAAA    2001:500:2d::d
e.root-servers.net.     604788  IN      A       192.203.230.10
f.root-servers.net.     604788  IN      A       192.5.5.241
f.root-servers.net.     604788  IN      AAAA    2001:500:2f::f
g.root-servers.net.     604788  IN      A       192.112.36.4
h.root-servers.net.     604788  IN      A       128.63.2.53
h.root-servers.net.     604788  IN      AAAA    2001:500:1::803f:235
i.root-servers.net.     604788  IN      A       192.36.148.17
i.root-servers.net.     604788  IN      AAAA    2001:7fe::53
j.root-servers.net.     604788  IN      A       192.58.128.30
j.root-servers.net.     604788  IN      AAAA    2001:503:c27::2:30
k.root-servers.net.     604788  IN      A       193.0.14.129
k.root-servers.net.     604788  IN      AAAA    2001:7fd::1
l.root-servers.net.     604788  IN      A       199.7.83.42
l.root-servers.net.     604788  IN      AAAA    2001:500:3::42
m.root-servers.net.     604788  IN      A       202.12.27.33
m.root-servers.net.     604788  IN      AAAA    2001:dc3::35

```
