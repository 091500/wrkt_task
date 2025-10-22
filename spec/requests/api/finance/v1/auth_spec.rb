describe API::Finance::V1::Auth, type: :request do
  let(:base_path) { '/api/v1/auth' }
  let(:email) { 'user@example.com' }
  let(:user) { create(:user, email: email) }
  let(:token) do
    post "#{base_path}/login", params: { email: email }
    JSON.parse(response.body)['data']['attributes']['token']
  end

  describe 'POST /register' do
    context 'when email is valid' do
      it 'returns 201 and a token' do
        post "#{base_path}/register", params: { email: email }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['token']).to be_present
      end
    end

    context 'when email is invalid' do
      it 'returns 400' do
        post "#{base_path}/register", params: { email: 'invalid' }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when organizer fails' do
      before do
        allow(RegisterOrganizer).to receive(:call)
          .and_return(OpenStruct.new(success?: false, error: 'Something went wrong'))
      end

      it 'returns error response' do
        post "#{base_path}/register", params: { email: email }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST /login' do
    context 'when login succeeds' do
      before do
        user
      end

      it 'returns 201 and token' do
        post "#{base_path}/login", params: { email: email }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['token']).to be_present
      end
    end

    context 'when login fails' do
      it 'returns 401' do
        post "#{base_path}/login", params: { email: "not_existing@example.com" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
