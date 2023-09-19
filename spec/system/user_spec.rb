# frozen_string_literal: true

require 'rails_helper'

describe "ユーザーテスト" do
  
  describe "新規ユーザー登録のテスト" do
    before do
      visit new_user_registration_path
    end
    
    context "フォームの確認" do
      it "nameフォームが表示される" do
        expect(page).to have_field "user[name]"
      end
      it "emailフォームが表示される" do
        expect(page).to have_field "user[email]"
      end
      it "passwordフォームが表示される" do
        expect(page).to have_field "user[password]"
      end
      it "password確認フォームが表示される" do
        expect(page).to have_field "user[password_confirmation]"
      end
    end
  
    context "登録処理のテスト" do
      before do
        fill_in "user[name]", with: Faker::Lorem.characters(number: 10)
        fill_in "user[email]", with: Faker::Internet.email
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
      end
      it "正しく新規登録される" do
        expect { click_button "登録" }.to change(User.all, :count).by(1)
      end
    end
  
  end
  
end