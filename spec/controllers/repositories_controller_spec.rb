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
end
