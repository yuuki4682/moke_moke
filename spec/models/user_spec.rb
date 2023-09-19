# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーモデルのテスト' do
  it "ユーザー登録が正常にされるか" do
    expect(FactoryBot.build(:user)).to be_valid
  end
end