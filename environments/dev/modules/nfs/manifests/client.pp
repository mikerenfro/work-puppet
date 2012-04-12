class nfs::client {
  # (http://nfsworld.blogspot.com/2005/06/using-active-directory-as-your-kdc-for.html)
  # (http://en.gentoo-wiki.com/wiki/Active_Directory_Authentication_using_LDAP)
  # Active Directory Kerberized NFSv4 client requires:
  # - user account in AD (username nfs<%= hostname.capitalize %>
  # - Kerberos principal linked to user account
  #   ktpass -princ nfs/<%= fqdn %>
  #          -mapuser nfs<%= hostname.capitalize %>
  #          +rndPass
  #          -ptype KRB5_NT_PRINCIPAL
  #          DesOnly
  #          -crypto DES-CBC-CRC
  #          -out UNIX<%= hostname %>.keytab
  include nfs::host
}
