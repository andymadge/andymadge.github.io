---
id: 243
title: 'Nagios Error "HTTP WARNING: HTTP/1.1 403 Forbidden"'
date: 2011-05-18T23:55:02+00:00
author: AndyM
layout: post
guid: http://www.andymadge.com/?p=243
categories:
  - Computers
---
When monitoring websites with Nagios, it's common to get the error "**HTTP WARNING: HTTP/1.1 403 Forbidden**".

### Quick Solution

Use the `-H` option to specify the host name for the web site e.g.

<pre>define service{
	use                     generic-service
	host_name               andymadge.com
	service_description     HTTP
	check_command           check_http!<strong>-H www.andymadge.com</strong>
}</pre>

<pre><!--more--></pre>

### Explanation

The default definition for the check_http command uses the -I option for the address:

<pre># 'check_http' command definition
define command{
	command_name	check_http
	command_line	$USER1$/check_http -I $HOSTADDRESS$ $ARG1$
}</pre>

According to the help (`check_http --help`) this option is used to specify the IP address or DNS name of the server to be checked.  If you specify a DNS name then Nagios does a lookup to convert it to the corresponding IP address.  In other words, the -I option will _always_ send the request to an IP address rather than a host name.

Since a single IP address can be home to many web sites, an IP address is often not enough to identify a particular website.  In this situation, web sites are identified by the _host header_ part of the HTTP request_._

So, the default check_http command contacts the correct web server, however the lack of host header in the request means the server doesn't know which actual web site to direct it to, therefore it responds with the 403 error.

To resolve this we need to use the -H option which specifies the hostname for the web site.  We could change the default command definition to use -H instead of -I however there are good reasons not to do this (see below)

The best solution is to specify the -H option in the service definition:

<pre>define service{
	use                     generic-service
	host_name               andymadge.com
	service_description     HTTP
	check_command           check_http!-H www.andymadge.com
}</pre>

Since the -I option is already specified in the command definition, we end up with the expanded check command:  
`check_http -I 72.52.225.30 -H www.andymadge.com`

This means the request is sent to IP address 72.52.225.30 but the request header also includes `host: www.andymadge.com`

In this case, the web server directs the request to the correct website, and responds with a HTTP OK 200  response.

### Why not change the default?

The advantage to leaving the default is that it allows you to do http checks without relying on DNS.

In the example above, DNS is not used at all, therefore Nagios is still able to monitor the website even if our DNS is down.