describe FindRecipient do
  subject do
    described_class.call(recipient_id: recipient_id)
  end

  context ".call" do
    context "when recipient exists" do
      let(:recipient) { create(:user) }
      let(:recipient_id) { recipient.id }

      it "sets the recipient in context" do
        result = subject
        expect(result).to be_a_success
        expect(result.recipient).to eq(recipient)
      end
    end

    context "when recipient does not exist" do
      let(:recipient_id) { -1 }

      it "fails with Recipient not found error" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Recipient not found")
        expect(result.error_code).to eq(404)
      end
    end
  end
end
