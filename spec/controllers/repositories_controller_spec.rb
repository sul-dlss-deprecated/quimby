# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  describe 'GET #index' do
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

  describe 'GET #show/:id' do
    let(:repo) { create(:repository) }

    it 'finds repo and renders show template' do
      get :show, params: { id: repo.id }
      expect(response.status).to eq 200
      expect(response).to render_template('show')
    end
  end
end
