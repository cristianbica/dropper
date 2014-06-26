module Droppper
  class SshKey < Resource
    @collection_url   = "/v2/account/keys"
    @collection_name  = "ssh_keys"
    @resource_url     = "/v2/account/keys/%{id}"
    @resource_name    = "ssh_key"

    attr_accessor :id, :fingerprint, :name, :public_key
  end
end
