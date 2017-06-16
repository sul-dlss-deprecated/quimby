# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  describe 'GET #index' do
    before do
      user = create(:user)
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end

    let(:repos) { create_list(:repository, 5) }

    it 'assigns @repositories' do
      get :index
      expect(assigns(:repositories)).to eq repos
    end
    it 'renders index' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
