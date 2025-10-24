describe TransferBalanceOrganizer do
  subject do
    described_class.call(user: user, recipient: recipient, amount: amount)
  end

  let(:user) { create(:user, email: "sender@example.com", balance: 200.0) }
  let(:recipient) { create(:user, email: "recipient@example.com", balance: 50.0) }
  let(:amount) { 75.0 }

  context ".call" do
    context "when transfer is successful" do
      it "deducts amount from user and adds to recipient" do
        result = subject
        expect(result).to be_a_success
        expect(user.reload.balance).to eq(125.0)
        expect(recipient.reload.balance).to eq(125.0)
      end
    end

    context "when user has insufficient balance" do
      let(:amount) { 250.0 }

      it "fails with Insufficient balance error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Insufficient funds")
        expect(user.reload.balance).to eq(200.0)
        expect(recipient.reload.balance).to eq(50.0)
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

    context "when recipient is not found" do
      let(:recipient) { nil }

      it "fails with Recipient not found error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Recipient not found")
      end
    end
  end
end
