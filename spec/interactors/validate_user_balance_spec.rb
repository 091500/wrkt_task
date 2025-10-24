describe ValidateUserBalance do
  let(:user) { create(:user, balance: 100.0) }
  let(:amount) { 50.0 }

  subject { described_class.call(user: user, amount: amount) }

  context "when user is not found" do
    let(:user) { nil }

    it "fails with user not found error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("User not found")
      expect(subject.error_code).to eq(404)
    end
  end

  context "when amount is invalid" do
    let(:amount) { "invalid" }

    it "fails with invalid amount error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Invalid amount")
      expect(subject.error_code).to eq(422)
    end
  end

  context "when amount is 0" do
    let(:amount) { 0 }

    it "fails with invalid amount error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Amount must be non-zero")
      expect(subject.error_code).to eq(422)
    end
  end

  context "when user has insufficient funds" do
    let(:amount) { -200.0 }

    it "fails with insufficient funds error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Insufficient funds")
      expect(subject.error_code).to eq(422)
    end
  end
end
