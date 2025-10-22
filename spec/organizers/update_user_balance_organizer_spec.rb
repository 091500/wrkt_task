describe UpdateUserBalanceOrganizer do
  subject { described_class.call(user_id: user_id, amount: amount) }

  let(:user) { create(:user, email: "new@example.com", balance: 100) }
  let(:user_id) { user.id }
  let(:amount) { 50 }

  context "when user exists and balance update is valid" do
    it "updates the user's balance successfully" do
      result = subject
      expect(result).to be_a_success
      expect(user.reload.balance).to eq(150)
    end
  end

  context "when user does not exist" do
    let(:user_id) { 0 }

    it "fails with User not found error" do
      result = subject
      expect(result).to be_a_failure
      expect(result.error).to eq("User not found")
    end
  end

  context "when balance update is invalid" do
    let(:amount) { -200 }

    it "fails with Insufficient funds error" do
      result = subject
      expect(result).to be_a_failure
      expect(result.error).to eq("Insufficient funds")
    end
  end

  context "when amount is not numeric" do
    let(:amount) { "fifty" }

    it "fails with Invalid amount error" do
      result = subject
      expect(result).to be_a_failure
      expect(result.error).to eq("Invalid amount")
    end
  end
end
