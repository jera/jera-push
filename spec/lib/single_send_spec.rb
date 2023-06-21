require 'rails_helper'

describe 'Enviar uma mensagem para um unico usuario' do
  before(:all) do
    FactoryBot.create(:user)
  end

  context 'passando imagem de roupas com diferente cores' do
    it 'vermelha' do
      byebug
    end
  end

end
