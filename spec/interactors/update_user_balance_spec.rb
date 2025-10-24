describe UpdateUserBalance do
  let(:user) { create(:user, balance: 100.0) }
  let(:amount) { 50.0 }

  subject { described_class.call(user: user, amount: amount) }

  context "when positive amount" do
    it "updates the user's balance" do
      expect(subject).to be_success
      expect(subject.user.balance).to eq(150.0)
    end
  end

  context "when negative amount" do
    let(:amount) { -50.0 }

    it "updates the user's balance" do
      expect(subject).to be_success
      expect(subject.user.balance).to eq(50.0)
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
