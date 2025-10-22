describe AuthTokenSerializer do
  let(:token) { "sample_token_123" }
  let(:auth_token) { double("AuthToken", token: token) }

  subject { described_class.new(auth_token) }

  describe "serialization" do
    it "includes the token in the serialized output" do
      serialized = subject.serializable_hash
      expect(serialized[:data][:id]).to eq(token)
      expect(serialized[:data][:type]).to eq(:token)
      expect(serialized[:data][:attributes][:token]).to eq(token)
    end
  end
end
