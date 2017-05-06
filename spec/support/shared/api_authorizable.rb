require 'rails_helper'

shared_examples_for "API authorizable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      send(http_method, path, params: { format: :json }.merge(try(:options) || {} ))
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      send(http_method, path,  params: { format: :json, access_token: '1234' }.merge(try(:options) || {} ))
      expect(response.status).to eq 401
    end
  end
end