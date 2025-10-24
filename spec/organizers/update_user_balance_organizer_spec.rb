describe UpdateUserBalanceOrganizer do
  subject do
    described_class.call(user: user, amount: amount)
  end

  let(:user) { create(:user, balance: 50) }
  let(:amount) { 100.0 }

  context ".call" do
    context "when update is successful" do
      it "updates the user's balance" do
        result = subject
        expect(result).to be_a_success
        expect(result.user.reload.balance).to eq(150.0)
      end
    end

    context "when user has insufficient balance for withdrawal" do
      let(:amount) { -150.0 }

      it "fails with Insufficient funds error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Insufficient funds")
        expect(user.reload.balance).to eq(50.0)
      end
    end

    context "when user is not set" do
      let(:user) { nil }

      it "fails with User not found error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("User not found")
      end
    end

    context "when amount is invalid" do
      let(:amount) { "invalid" }

      it "fails with Invalid amount error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Invalid amount")
      end
    end

    context "when amount is zero" do
      let(:amount) { 0.0 }

      it "fails with Amount must be non-zero error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Amount must be non-zero")
      end
    end
  end
end
