require "gds_api/asset_manager"
require "plek"

# Need to provide a bearer token to authenticate to the asset manager.
# This can be loaded from an environment variable, or this file can
# be overwritten with the correct details on deploy.
# See README.md for details of how to generate a bearer token.

Attachable.asset_api_client = GdsApi::AssetManager.new(
  Plek.current.find("asset-manager"),
  bearer_token: ENV["ASSET_MANAGER_BEARER_TOKEN"] || "example",
)
