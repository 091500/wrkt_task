describe RegisterUser do
  subject do
    described_class.call(email: email)
  end

  context ".call" do
    before(:each) do
      allow(APILogger).to receive(:info)
    end

    context "when registration is successful" do
      let(:email) { "new_user@example.com" }

      it "creates a new user and sets it in context" do
        result = subject
        expect(result).to be_a_success
        expect(result.user).to be_present
        expect(result.user.email).to eq(email)
        expect(APILogger).to have_received(:info).with("[registration][user #{result.user.id}] email: #{email}")
      end
    end

    context "when registration fails" do
      let(:email) { "" }

      it "fails with an appropriate error message" do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq("Email can't be blank")
        expect(APILogger).not_to have_received(:info)
      end
    end
  end
end
