describe RegisterUser do
  subject do
    described_class.call(email: email)
  end

  context ".call" do
    context "when registration is successful" do
      let(:email) { "new_user@example.com" }

      it "creates a new user and sets it in context" do
        result = subject
        expect(result).to be_a_success
        expect(result.user).to be_present
        expect(result.user.email).to eq(email)
      end
    end

    context "when registration fails" do
      let(:email) { "" }

      it "fails with an appropriate error message" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Email can't be blank, Email is invalid")
      end
    end
  end
end
