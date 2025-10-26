describe JsonWebToken do
  let(:payload) { { user_id: 1 } }
  let(:token) { JsonWebToken.encode(payload, 1.hour.from_now) }

  describe ".encode" do
    it "encodes the payload into a JWT token" do
      expect(token).not_to be_nil
      decoded_payload = JsonWebToken.decode(token)
      expect(decoded_payload[:user_id]).to eq(payload[:user_id])
    end
  end

  describe ".decode" do
    context "with a valid token" do
      it "decodes the JWT token back into the payload" do
        decoded_payload = JsonWebToken.decode(token)
        expect(decoded_payload[:user_id]).to eq(payload[:user_id])
      end
    end

    context "with an invalid token" do
      let(:invalid_token) { "invalid.token.string" }

      it "returns nil for an invalid token" do
        decoded_payload = JsonWebToken.decode(invalid_token)
        expect(decoded_payload).to be_nil
      end
    end

    context "with an expired token" do
      let(:expired_token) { JsonWebToken.encode(payload, 1.second.ago) }

      it "returns nil for an expired token" do
        decoded_payload = JsonWebToken.decode(expired_token)
        expect(decoded_payload).to be_nil
      end
    end

    context "with a nil token" do
      it "returns nil" do
        decoded_payload = JsonWebToken.decode(nil)
        expect(decoded_payload).to be_nil
      end
    end
  end
end
