describe UserSerializer do
  let(:user) { create(:user, email: "test@user.com", balance: 150.0) }

  subject { described_class.new(user).serializable_hash }

  describe "serialization" do
    it "includes the correct attributes" do
      expect(subject[:data][:id]).to eq(user.id.to_s)
      expect(subject[:data][:type]).to eq(:user)
      expect(subject[:data][:attributes][:balance]).to eq(150.0)
    end
  end
end
