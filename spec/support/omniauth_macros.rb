module OmniauthMacros
  def mock_auth_hash(provider, email)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '123545',
      info: { email: email}
      })
  end
end