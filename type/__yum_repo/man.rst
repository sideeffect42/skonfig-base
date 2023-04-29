cdist-type__yum_repo(7)
=======================

NAME
----
cdist-type__yum_repo - Manage yum repositories


DESCRIPTION
-----------
This type allows you to configure yum repositories.


REQUIRED PARAMETERS
-------------------
None.


OPTIONAL PARAMETERS
-------------------
state
   One of:

   ``present``
      The repository is configured.
   ``absent``
      The repository is not configured.

   Defaults to: ``present``
name
   A human readable string describing the repository.
baseurl
   Must be a URL to the directory where the yum repository's ``repodata``
   directory lives.
   Can be an http://, ftp:// or file:// URL.

   Can be specified multiple times.
metalink
   Specifies a URL to a metalink file for the ``repomd.xml``.
mirrorlist
   Specifies a URL to a file containing a list of baseurls.
   This can be used instead of or with the ``--baseurl`` parameter.
gpgkey
   A URL pointing to the ASCII-armored GPG key file for the repository.

   Can be specified multiple times.
gpgcakey
   A URL pointing to the ASCII-armored CA key file for the repository.
exclude
   List of packages to exclude from updates or installs. Shell globs are allowed.

   Can be specified multiple times.
includepkgs
   The inverse of ``--exclude``.
   A list of packages to use from this repository.

   Can be specified multiple times.
failovermethod
   The strategy yum should use to select URLs from baseurls.
timeout
   Number of seconds to wait for a connection before timing out.
http_caching
   Determines how upstream HTTP caches are instructed to handle any HTTP
   downloads that Yum does.
retries
   Set the number of times any attempt to retrieve a file should retry before
   returning an error.
throttle
   Configure bandwidth throttling for downloads.
bandwidth
   The maximum available network bandwidth in bytes/second.
sslcacert
   Path to the directory containing the databases of the certificate authorities
   yum should use to verify SSL certificates.
sslclientcert
   Path to the SSL client certificate yum should use to connect to this
   repository.
sslclientkey
   Path to the SSL client key yum should use to connect to this repository.
metadata_expire
   Time (in seconds) after which the metadata will expire.
mirrorlist_expire
   Time (in seconds) after which the mirrorlist locally cached will expire.
proxy
   URL to the proxy server for this repository.
   Set to ``_none_`` to disable the global proxy setting for this repository.
proxy_username
   The username to use for the ``--proxy``.
proxy_password
   The password to use with ``--proxy_username`` for the ``--proxy``.
username
   The username to use for bacic authentication.
password
   The password to use with ``--username`` for basic authentication.
cost
   The relative cost of accessing this repository.


BOOLEAN PARAMETERS
------------------
disablegroups
   Tell yum to *not* use package groups for this repository.
enabled
   Tell yum to use this repository.
gpgcheck
   Tell yum to perform GPG signature checks on the packages gotten from this
   repository.
keepalive
   Tell yum to use HTTP/1.1 keepalive for this repository.
no-ssl_check_cert_permissions
   Tell yum to not check the permissions on the paths for the certificates on
   the repository (both remote and local).
no-sslverify
   Tell yum to not verify SSL certificates/hosts at all.
repo_gpgcheck
   Tell yum to perform a GPG signature check on the repodata from this
   repository.
skip_if_unavailable
   Tell yum to continue running even if this repository cannot be contacted for
   some reason.


EXAMPLES
--------

.. code-block:: sh

    __yum_repo epel \
       --name 'Extra Packages for Enterprise Linux 6 - $basearch' \
       --mirrorlist 'https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch' \
       --failovermethod priority \
       --enabled \
       --gpgcheck 1 \
       --gpgkey https://fedoraproject.org/static/0608B895.txt


SEE ALSO
--------
- :strong:`yum.conf`\ (5)


AUTHORS
-------
| Steven Armstrong <steven-cdist--@--armstrong.cc>
| Dennis Camera <dennis.camera--@--riiengineering.ch>


COPYING
-------
Copyright \(C) 2014 Steven Armstrong, 2023 Dennis Camera.
You can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.
