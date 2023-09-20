require 'rails_helper'

RSpec.describe "application_helper", type: :helper do
  describe "#full_title(page_title)" do
    context "引数が空白の場合" do
      it "定数BASE_TITLEだけが表示されること" do
        expect(helper.full_title("")).to eq("GO TO place")
      end
    end

    context "引数がnilの場合" do
      it "定数BASE_TITLEだけが表示されること" do
        expect(helper.full_title(nil)).to eq("GO TO place")
      end
    end

    context "引数が空文字で渡されている場合" do
      it "定数BASE_TITLEだけが表示されること" do
        expect(helper.full_title(" ")).to eq("GO TO place")
      end
    end

    context "引数が渡されている場合" do
      it "引数+定数BASE_TITLEで表示されること" do
        expect(helper.full_title("test")).to eq("test - GO TO place")
      end
    end
  end
end
