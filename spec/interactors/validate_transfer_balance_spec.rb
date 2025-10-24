describe ValidateTransferBalance do
  let(:user) { create(:user, balance: 100.0) }
  let(:recipient) { create(:user, balance: 50.0, email: "user@test.com") }
  let(:amount) { 30.0 }

  subject { described_class.call(user: user, recipient: recipient, amount: amount) }

  context "when user is not found" do
    let(:user) { nil }

    it "fails with user not found error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("User not found")
      expect(subject.error_code).to eq(404)
    end
  end

  context "when recipient is not found" do
    let(:recipient) { nil }

    it "fails with recipient not found error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Recipient not found")
      expect(subject.error_code).to eq(404)
    end
  end

  context "when transferring to self" do
    let(:recipient) { user }

    it "fails with cannot transfer to self error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Cannot transfer to self")
      expect(subject.error_code).to eq(422)
    end
  end

  context "when amount is less than or equal to zero" do
    let(:amount) { 0.0 }

    it "fails with invalid transfer amount error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Transfer amount must be greater than zero")
    end
  end

  context "when user has insufficient funds" do
    let(:amount) { 200.0 }

    it "fails with insufficient funds error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Insufficient funds")
    end
  end
end
