# frozen_string_literal: true

require 'rails_helper'

describe "投稿機能のテスト" do
  let!(:user) {create(:user)}
  let!(:work) {create(:work)}
  let!(:tag) {create(:tag)}
  before do
    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    click_button "ログイン"
  end
  describe "新規投稿のテスト" do
    context "新規投稿画面の表示テスト" do
      before do
        visit new_work_path
      end
      it "URLの確認" do
        expect(current_path).to eq "/works/new"
      end
      it "表示の確認" do
        expect(page).to have_field "work[title]"
        expect(page).to have_field "work[name]"
        expect(page).to have_field "work[caption]"
        expect(page).to have_field "work[main_image]"
        expect(page).to have_field "work[sub_images][]"
      end
    end
    
    context "投稿処理のテスト" do
      before do
        visit new_work_path
        fill_in "work[title]", with: Faker::Lorem.characters(number: 20)
        fill_in "work[name]", with: Faker::Lorem.characters(number: 10) + "," + Faker::Lorem.characters(number: 10)
        fill_in "work[caption]", with: Faker::Lorem.characters(number: 200)
        attach_file 'work[main_image]', File.join(Rails.root, 'spec/images/test1.jpg')
        attach_file 'work[sub_images][]', File.join(Rails.root, 'spec/images/test2.jpg')
      end
      it "正しく投稿される" do
        expect { click_button "投稿する" }.to change(Work.all, :count).by(1)
      end
      it "マイページに遷移する" do
        click_button "投稿する"
        expect(current_path).to eq "/works/" + Work.last.id.to_s
      end
    end
    context "投稿詳細画面のテスト" do
      before do
        visit work_path(work)
      end
      it "URLが正しい" do
        expect(current_path).to eq "/works/" + work.id.to_s
      end
      it "titleが表示されている" do
        expect(page).to have_content work.title
      end
      it "captionが表示されている" do
        expect(page).to have_content work.caption
      end
      it "main_imageが表示されている" do
        expect(page).to have_selector("img[src$='test1.jpg']")
      end
      it "sub_imageが表示されている" do
        expect(page).to have_selector("img[src$='test2.jpg']")
      end
    end
  end
end