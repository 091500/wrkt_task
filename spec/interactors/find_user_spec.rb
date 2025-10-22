describe FindUser do
  subject do
    described_class.call(user_id: user_id)
  end

  context ".call" do
    context "when user exists" do
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it "sets the user in context" do
        result = subject
        expect(result).to be_a_success
        expect(result.user).to eq(user)
      end
    end

    context "when user does not exist" do
      let(:user_id) { -1 }

      it "fails with User not found error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("User not found")
        expect(result.error_code).to eq(404)
      end
    end
  end
end
