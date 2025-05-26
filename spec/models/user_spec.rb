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
         expect(user).to be_invalid
       end

       it 'メールアドレスが無い場合、無効であること' do
        user = build(:user)
        user.email = nil
        expect(user).to be_invalid
      end

       it 'パスワードが無い場合、無効であること' do
        user = build(:user)
        user.password = nil
        expect(user).to be_invalid
      end

      it 'パスワードとパスワード確認が一致しない場合、無効であること' do
        user = build(:user)
        user.password_confirmation = 'different_password'
        user.valid?
        expect(user.errors[:password_confirmation]).to be_present
      end
  
      it 'メールはユニークであること' do
        user1 = create(:user)
        user2 = build(:user)
        user2.email = user1.email
        user2.valid?
        expect(user2.errors[:email]).to include('has already been taken')
      end

      it '無効なメール形式の場合、無効であること' do
        user = build(:user, email: 'pojihome-com')
        user.valid?
        expect(user.errors[:email]).to be_present
      end  

      it 'パスワードが6文字未満の場合、無効であること' do
        user = build(:user, password: 'short', password_confirmation: 'short')
        user.valid?
        expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end
    end  
  end
end
