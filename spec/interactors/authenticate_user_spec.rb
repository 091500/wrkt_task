describe AuthenticateUser do
  subject { described_class.call(user: user) }

  context "when credentials are valid" do
    let(:user) { create(:user, email: "test@user.com") }

    it "generates a token" do
      expect(subject).to be_success
      expect(subject.token).not_to be_nil
    end
  end

  context "when credentials are invalid" do
    let(:user) { build(:user, email: "1@test.com") }

    it "fails with invalid credentials error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Invalid credentials")
    end
  end
end
