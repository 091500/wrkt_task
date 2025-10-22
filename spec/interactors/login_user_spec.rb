describe LoginUser do
  subject do
    described_class.call(email: email)
  end

  context ".call" do
    context "when user exists" do
      let(:user) { create(:user) }
      let(:email) { user.email }

      it "sets the user in context" do
        result = subject
        expect(result).to be_a_success
        expect(result.user).to eq(user)
      end
    end

    context "when user does not exist" do
      let(:email) { "no@example.com" }
      it "fails with User not found error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("User not found")
      end
    end
  end
end
