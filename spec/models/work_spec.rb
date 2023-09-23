# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Workモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { work.valid? }
    let(:work) { build(:work) }
    
    context 'titleカラムのテスト' do
      it '空白=>NG' do
        work.title = ""
        is_expected.to eq false
      end
      it '20文字以内=>OK' do
        work.title = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it "21文字以上=>NG" do
        work.title = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end
    
    context "captionカラムのテスト" do
      it "空白=>NG" do
        work.caption = ""
        is_expected.to eq false
      end
      it "200文字以内=>OK" do
        work.caption = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it "201文字以上=>NG" do
        work.caption = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end
  
   describe "アソシエーションのテスト" do
    context "Workモデルと他モデルとの関係" do
      it "Likeモデルと1:N" do
        expect(Work.reflect_on_association(:likes).macro).to eq :has_many
      end
      it "Commentモデルと1:N" do
        expect(Work.reflect_on_association(:comments).macro).to eq :has_many
      end
      it "ViewCountモデルと1:N" do
        expect(Work.reflect_on_association(:view_counts).macro).to eq :has_many
      end
      it "WprkTagモデルと1:N" do
        expect(Work.reflect_on_association(:work_tags).macro).to eq :has_many
      end
      it "Notificationモデルと1:N" do
        expect(Work.reflect_on_association(:notifications).macro).to eq :has_many
      end
      it "Reportモデルと1:N" do
        expect(Work.reflect_on_association(:reports).macro).to eq :has_many
      end
    end
  end
end