describe API::Finance::V1::Users, type: :request do
  let(:base_path) { '/api/v1/users' }
  let(:token) { 'fake-jwt-token' }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /me' do
    let(:user) { build_stubbed(:user, id: 1, email: 'user@example.com') }

    before do
      allow_any_instance_of(API::Finance::V1::Helpers::Auth).to receive(:authenticate!)
      allow_any_instance_of(API::Finance::V1::Helpers::Auth).to receive(:current_user).and_return(user)
    end

    it 'returns current user details' do
      get "#{base_path}/me", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['email']).to eq(user.email)
    end

    it 'returns 401 if unauthorized' do
      allow_any_instance_of(API::Finance::V1::Helpers::Auth).to receive(:authenticate!)
        .and_raise(Grape::Exceptions::Base.new(status: 401))
      get "#{base_path}/me"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /:id' do
    let(:user) { build_stubbed(:user, id: 1, email: 'user@example.com') }

    before do
      allow_any_instance_of(API::Finance::V1::Helpers::Auth).to receive(:authenticate!)
      allow(FindUser).to receive(:call)
        .with(user_id: user.id)
        .and_return(OpenStruct.new(success?: true, user: user))
    end

    it 'returns user by ID' do
      get "#{base_path}/#{user.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['email']).to eq(user.email)
    end

    it 'returns 404 if user not found' do
      allow(FindUser).to receive(:call)
        .and_return(OpenStruct.new(success?: false, error: 'User not found', error_code: 404))
      get "#{base_path}/999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /:id/balance' do
    let(:user) { build_stubbed(:user, id: 1, email: 'user@example.com') }

    before do
      allow_any_instance_of(API::Finance::V1::Helpers::Auth).to receive(:authenticate!)
    end

    context 'when successful' do
      before do
        allow(UpdateUserBalanceOrganizer).to receive(:call)
          .and_return(OpenStruct.new(success?: true, user: user))
      end

      it 'updates balance' do
        patch "#{base_path}/#{user.id}/balance", params: { amount: 50.0 }, headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid amount' do
      before do
        allow(UpdateUserBalanceOrganizer).to receive(:call)
          .and_return(OpenStruct.new(success?: false, error: 'Invalid amount'))
      end

      it 'returns 400' do
        patch "#{base_path}/#{user.id}/balance", params: { amount: 'invalid' }, headers: headers
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH /:id/transfer_balance' do
    let(:user) { build_stubbed(:user, id: 1) }

    before do
      allow_any_instance_of(API::Finance::V1::Helpers::Auth).to receive(:authenticate!)
    end

    context 'when successful' do
      before do
        allow(TransferUserBalanceOrganizer).to receive(:call)
          .and_return(OpenStruct.new(success?: true, user: user))
      end

      it 'transfers successfully' do
        patch "#{base_path}/#{user.id}/transfer_balance",
          params: { recipient_id: 2, amount: 100.0 },
          headers: headers

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when insufficient funds' do
      before do
        allow(TransferUserBalanceOrganizer).to receive(:call)
          .and_return(OpenStruct.new(success?: false, error: 'Insufficient funds', error_code: 422))
      end

      it 'returns 422' do
        patch "#{base_path}/#{user.id}/transfer_balance",
          params: { recipient_id: 2, amount: 99999.0 },
          headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
