describe RegisterOrganizer do
  subject do
    described_class.call(email: email)
  end

  context "when successful registration" do
    let(:email) { "new@example.com" }

    it "registers and authenticates the user, returning user and token" do
      result = subject
      expect(result).to be_a_success
      expect(result.user).to be_present
      expect(result.user.email).to eq(email)
      expect(result.token).not_to be_nil
    end
  end

  context "when registration fails" do
    let(:email) { "" }

    it "fails with appropriate error message" do
      result = subject
      expect(result).to be_a_failure
      expect(result.error).to eq("Email can't be blank")
    end
  end
end
