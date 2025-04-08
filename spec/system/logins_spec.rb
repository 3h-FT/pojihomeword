require 'rails_helper'

RSpec.describe "ログイン機能", type: :system do
  let(:user) { create(:user) }

  before { login(user) }

  it 'トップページにリダイレクトされること' do
    expect(page.current_path).to eq(root_path)
  end
end
