require 'rails_helper'

RSpec.describe "ログイン機能", type: :system do
  let(:user) { create(:user) }

  before { login(user) }

  it 'トップページにリダイレクトされること' do
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Signed in successfully.')
  end
end
