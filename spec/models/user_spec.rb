# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe "バリデーションのテスト" do
    subject { user.valid? }
    let(:user) { build(:user) }
    
    context "nameカラムのテスト" do
      it "空白=>NG" do
        user.name = ""
        is_expected.to eq false
      end
      it "20文字以内=>OK" do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it "21文字以上=>NG" do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end
    
    context "introductionカラムのテスト" do
      it "空白=>OK" do
        user.introduction = ""
        is_expected.to eq true
      end
      it "100文字以内=>OK" do
        user.introduction = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it "21文字以上=>NG" do
        user.introduction = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end
  
  describe "アソシエーションのテスト" do
    context "Userモデルと他モデルとの関係" do
      it "Workモデルと1:N" do
        expect(User.reflect_on_association(:works).macro).to eq :has_many
      end
      it "Likeモデルと1:N" do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
      it "Commentモデルと1:N" do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
      it "ViewCountモデルと1:N" do
        expect(User.reflect_on_association(:view_counts).macro).to eq :has_many
      end
      it "Chatモデルと1:N" do
        expect(User.reflect_on_association(:chats).macro).to eq :has_many
      end
      it "UserRoomモデルと1:N" do
        expect(User.reflect_on_association(:user_rooms).macro).to eq :has_many
      end
      it "Notificationモデルのvisitorと1:N" do
        expect(User.reflect_on_association(:notifications).macro).to eq :has_many
      end
      it "Notificationモデルのvisitedと1:N" do
        expect(User.reflect_on_association(:reverse_notifications).macro).to eq :has_many
      end
      it "Reportモデルのreporterと1:N" do
        expect(User.reflect_on_association(:reports).macro).to eq :has_many
      end
      it "Reportモデルのreportedと1:N" do
        expect(User.reflect_on_association(:reverse_reports).macro).to eq :has_many
      end
      it "Relationshipモデルのfollowerと1:N" do
        expect(User.reflect_on_association(:relationships).macro).to eq :has_many
      end
      it "Relationshipモデルのfollowedと1:N" do
        expect(User.reflect_on_association(:reverse_relationships).macro).to eq :has_many
      end
    end
  end
end
