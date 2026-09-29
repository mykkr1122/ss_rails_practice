require "rails_helper"

RSpec.describe Address, type: :model do
  it "同じ注文に同じaddress_typeを2件保存しようとするとDB制約でエラーになる" do
    order = orders(:one)
    duplicate = order.addresses.build(
      address_type: "Shipping", postal_code: "9999999",
      prefecture: "北海道", city: "札幌市", address_line: "1-1"
    )

    expect { duplicate.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "postal_codeがない場合はエラーになる" do
    address = orders(:one).addresses.build(
      address_type: "Shipping", 
      prefecture: "東京都", city: "千代田区", address_line: "1-1-1"
    )
    expect(address).not_to be_valid
    expect(address.errors[:postal_code]).to be_present
  end

  it "postal_codeが7桁の数字以外だと保存できない" do
    address = orders(:one).addresses.build(
      address_type: "Shipping", postal_code: "abc-1234",
      prefecture: "東京都", city: "千代田区", address_line: "1-1-1"
    )
    expect(address).not_to be_valid
  end
  
  it "address_typeがShipping/Billing以外だと保存できない" do
    address = orders(:one).addresses.build(
      address_type: "Other", postal_code: "1000001",
      prefecture: "東京都", city: "千代田区", address_line: "1-1-1"
    )
    expect(address).not_to be_valid
  end
end
