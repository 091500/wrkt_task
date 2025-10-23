describe API::V1::UsersController, type: :request do
  let(:base_path) { '/api/v1' }
  let(:email) { 'user@example.com' }
  let(:balance) { 0 }
  let(:user) { create(:user, email: email, balance: balance) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:token) do
    post "/api/v1/login", params: { email: email }
    JSON.parse(response.body)['data']['attributes']['token']
  end

  describe 'GET /me' do
    before do
      user
    end

    it 'returns current user details' do
      get "#{base_path}/me", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['email']).to eq(user.email)
    end

    it 'returns 401 if not authenticated' do
      get "#{base_path}/me"
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when error occurs in current_user' do
      before do
        allow(JsonWebToken).to receive(:decode)
          .and_raise(JWT::DecodeError.new("Unexpected error"))
      end

      it 'returns 401' do
        get "#{base_path}/me", headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /update_balance' do
    before(:each) do
      user
    end

    context 'when successful' do
      it 'updates balance' do
        patch "#{base_path}/update_balance", params: { amount: 50 }, headers: headers
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['data']['attributes']['balance']).to eq("50.0")
        expect(user.reload.balance).to eq(50)
      end
    end

    context 'when invalid amount' do
      it 'returns 422' do
        patch "#{base_path}/update_balance", params: { amount: 'invalid' }, headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)['error']).to eq('Invalid amount')
        expect(user.reload.balance).to eq(0)
      end
    end

    context 'when insufficient funds' do
      let(:balance) { 10 }

      it 'returns 422' do
        patch "#{base_path}/update_balance", params: { amount: -11 }, headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient funds')
        expect(user.reload.balance).to eq(10)
      end
    end
  end

  describe 'PATCH /transfer_balance' do
    let(:balance) { 100.0 }
    let(:recipient) { create(:user, email: 'recipient@example.com', balance: 0) }

    before(:each) do
      user
    end

    context 'when successful' do
      it 'transfers successfully' do
        patch "#{base_path}/transfer_balance",
          params: { recipient_id: recipient.id, amount: 50 },
          headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['balance']).to eq("50.0")
        expect(user.reload.balance).to eq(50)
        expect(recipient.reload.balance).to eq(50)
      end
    end

    context 'when insufficient funds' do
      let(:balance) { 30 }

      it 'returns 422' do
        patch "#{base_path}/transfer_balance",
          params: { recipient_id: recipient.id, amount: 31 },
          headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient funds')
        expect(user.reload.balance).to eq(30)
      end
    end

    context 'when invalid amount' do
      it 'returns 422' do
        patch "#{base_path}/transfer_balance",
          params: { recipient_id: recipient.id, amount: 'invalid' },
          headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)['error']).to eq('Invalid amount')
        expect(user.reload.balance).to eq(100)
      end
    end
  end
end
