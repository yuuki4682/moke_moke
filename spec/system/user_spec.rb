# frozen_string_literal: true

require 'rails_helper'

describe "ユーザー機能のテスト" do
  let(:user) {create(:user)}
  
  describe "新規ユーザー登録のテスト" do
    before do
      visit new_user_registration_path
    end
    
    context "新規登録フォームの確認" do
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
      it "マイページに遷移する" do
        click_button "登録"
        expect(current_path).to eq "/mypage"
      end
    end
  end
  describe "ユーザー情報編集のテスト" do
    before do
      visit new_user_session_path
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: user.password
      click_button "ログイン"
      visit edit_user_path(user)
    end
    context "表示の確認" do
      it "URLの確認" do
        expect(current_path).to eq "/users/" + user.id.to_s + "/edit"
      end
      it "フォーム内情報の確認" do
        expect(page).to have_field "user[name]", with: user.name
        expect(page).to have_field "user[profile_image]"
        expect(page).to have_field "user[introduction]", with: user.introduction
        expect(page).to have_button "編集する"
      end
    end
    context "更新のテスト" do
      before do
        @old_user_name = user.name
        @old_user_introduction = user.introduction
        fill_in "user[name]", with: Faker::Lorem.characters(number: 5)
        fill_in "user[introduction]", with: Faker::Lorem.characters(number: 20)
        attach_file 'user[profile_image]', File.join(Rails.root, 'spec/images/profile_image.jpg')
        click_button "編集する"
        save_page
      end
      it "正しく更新される" do
        expect(user.reload.name).not_to eq @old_user_name
        expect(user.reload.introduction).not_to eq @old_user_introduction
        expect(user.reload.profile_image).not_to eq @user_old_profile_image
      end
      it "マイページに遷移される" do
        expect(current_path).to eq "/mypage"
      end
    end
  end
end