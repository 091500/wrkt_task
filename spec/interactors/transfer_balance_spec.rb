describe TransferBalance do
  let(:user) { create(:user, balance: 100.0) }
  let(:recipient) { create(:user, balance: 50.0, email: "user@test.com") }
  let(:amount) { 30.0 }

  subject { described_class.call(user: user, recipient: recipient, amount: amount) }

  context "when transfer is successful" do
    it "deducts amount from user and adds to recipient" do
      expect(subject).to be_success
      expect(subject.user.balance).to eq(70.0)
      expect(subject.recipient.balance).to eq(80.0)
    end
  end

  context "when ActiveRecord::RecordInvalid is raised" do
    before do
      allow(FinanceTransaction).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new)
    end

    it "fails with the exception message" do
      expect(subject).to be_failure
      expect(subject.error).to eq("Record invalid")
    end
  end
end
