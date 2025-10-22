describe LoginOrganizer do
  subject { described_class.call(email: email) }

  let(:email) { "test@user.com" }

  context 'when credentials are valid' do
    let(:user) { create(:user, email: email) }

    before do
      user
    end

    it 'logs in the user successfully, generates token' do
      result = subject
      expect(result).to be_a_success
      expect(result.user).to eq(user)
      expect(result.token).not_to be_nil
    end
  end

  context 'when credentials are invalid' do
    let(:email) { "ivalid@email.com" }

    it 'fails with error' do
      result = subject
      expect(result).to be_a_failure
      expect(result.error).to eq("User not found")
    end
  end
end
