class nfs::client {
  # (http://nfsworld.blogspot.com/2005/06/using-active-directory-as-your-kdc-for.html)
  # Active Directory Kerberized NFSv4 client requires:
  # - user account in AD (username nfs<%= hostname.capitalize %>
  # - Kerberos principal linked to user account
  #   ktpass -princ nfs/<%= fqdn %>
  #          -mapuser nfs<%= hostname.capitalize %>
  #          -pass ____
  #          -out UNIX<%= hostname %>.keytab
  include nfs::host
}
