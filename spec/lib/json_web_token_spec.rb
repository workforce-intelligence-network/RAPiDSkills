require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:payload) {
    {
      user_id: 1,
      password_digest: "abc123$",
    }
  }

  it "returns a JWT encoded payload which can be decoded" do
    encoded_jwt = described_class.encode(payload)
    decoded_jwt = described_class.decode(encoded_jwt)
    expect(decoded_jwt[:user_id]).to eq 1
    expect(decoded_jwt[:password_digest]).to eq "abc123$"
  end
end
