require 'rails_helper'

RSpec.describe User, type: :model do
  context "バリデーション" do
    context "有効な場合" do
       it 'ユーザー名、メールがあり、パスワードは6文字以上であれば有効であること' do
        user = build(:user)
        expect(user).to be_valid
       end
    end

    context "無効な場合" do
       it 'ユーザー名が無い場合、無効であること' do
         user = build(:user)
         user.username = nil
         expect(user).to_not be_valid
       end

       it 'メールアドレスが無い場合、無効であること' do
        user = build(:user)
        user.email = nil
        expect(user).to_not be_valid
      end

       it 'パスワードが無い場合、無効であること' do
        user = build(:user)
        user.password = nil
        expect(user).to_not be_valid
      end

       it 'パスワードとパスワード確認が一致しない場合、無効であること' do
        user = build(:user)
        user.password_confirmation = 'different_password'
        expect(user).to_not be_valid
      end
    end

  it 'メールはユニークであること' do
    user1 = create(:user)
    user2 = build(:user)
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include('has already been taken')
  end

  it 'パスワードが6文字未満の場合、無効であること' do
    user = build(:user, password: 'short', password_confirmation: 'short')
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end
 end
end
