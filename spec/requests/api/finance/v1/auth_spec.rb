describe API::Finance::V1::Auth, type: :request do
  let(:base_path) { '/api/v1/auth' }

  describe 'POST /register' do
    let(:email) { 'user@example.com' }

    context 'when email is valid' do
      before do
        allow(RegisterOrganizer).to receive(:call)
          .with(email: email)
          .and_return(OpenStruct.new(success?: true, token: 'fake-jwt-token'))
      end

      it 'returns 201 and a token' do
        post "#{base_path}/register", params: { email: email }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['token']).to eq('fake-jwt-token')
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
    let(:email) { 'user@example.com' }

    context 'when login succeeds' do
      before do
        allow(LoginOrganizer).to receive(:call)
          .with(email: email)
          .and_return(OpenStruct.new(success?: true, token: 'jwt-login-token'))
      end

      it 'returns 201 and token' do
        post "#{base_path}/login", params: { email: email }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['token']).to eq('jwt-login-token')
      end
    end

    context 'when login fails' do
      before do
        allow(LoginOrganizer).to receive(:call)
          .and_return(OpenStruct.new(success?: false, error: 'Invalid credentials'))
      end

      it 'returns 401' do
        post "#{base_path}/login", params: { email: email }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
