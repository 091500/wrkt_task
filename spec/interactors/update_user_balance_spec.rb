describe UpdateUserBalance do
  let(:user) { create(:user, balance: 100.0) }
  let(:amount) { 50.0 }

  subject { described_class.call(user: user, amount: amount) }

  context "when positive amount" do
    it "updates the user's balance" do
      expect(subject).to be_success
      expect(subject.user.balance).to eq(150.0)
    end

    it 'creates a deposit transaction' do
      expect {
        subject
      }.to change { FinanceTransaction.where(recipient: user, transaction_type: 'deposit', amount: amount.abs).count }.by(1)
    end
  end

  context "when negative amount" do
    let(:amount) { -50.0 }

    it "updates the user's balance" do
      expect(subject).to be_success
      expect(subject.user.balance).to eq(50.0)
    end

    it 'creates a withdrawal transaction' do
      expect {
        subject
      }.to change { FinanceTransaction.where(sender: user, transaction_type: 'withdrawal', amount: amount.abs).count }.by(1)
    end
  end

  context 'when invalid amount' do
    let(:amount) { 'test' }

    it 'fails with the appropriate error message' do
      expect(subject).to be_failure
      expect(subject.error).to eq('Invalid amount')
    end
  end

  context "when amount is zero" do
    let(:amount) { 0.0 }
    it "fails with amount must be non-zero error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Amount must be non-zero")
    end
  end

  context "when insufficient funds" do
    let(:amount) { -150.0 }

    it "fails with insufficient funds error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Insufficient funds")
    end
  end

  context "when user not found" do
    let(:user) { nil }

    it "fails with user not found error" do
      expect(subject).to be_failure
      expect(subject.error).to eq("User not found")
    end
  end

  context "when ActiveRecord::RecordInvalid is raised" do
    before do
      allow_any_instance_of(User).to receive(:increment!).and_raise(ActiveRecord::RecordInvalid.new(user))
    end

    it "fails with the exception message" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Validation failed: ")
    end
  end
end
