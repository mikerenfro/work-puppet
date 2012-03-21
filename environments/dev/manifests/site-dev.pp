node default {}

node gold {
  include ssh
}

node scratchy {
  include ssh
  include root_rsa_id
}
