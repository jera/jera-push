require 'rails_helper'

describe 'Enviar uma mensagem para um unico usuario' do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context 'usuario com informações validas' do
    it 'envia uma nova mensagem para o usuario especifico' do
      @user.devices.create(token: Faker::Crypto.sha256, platform: :android)

      VCR.use_cassette('firebase_send_single_push') do
        @response = JeraPush::Services::SendMessageToUserService.new(user: @user, title: 'Push Title Test', body: 'Push Body Test').call
      end

      expect(@response.multicast_id).to eq('108')
      expect(@response.success_count).to eq(1)
      expect(@response.failure_count).to eq(0)
    end
  end

  context 'usuario com informações invalidas' do
    it 'a mensaagem nao é enviada e um erro é disparado' do
      VCR.use_cassette('firebase_send_single_push') do
        @response = JeraPush::Services::SendMessageToUserService.new(user: @user, title: 'Push Title Test', body: 'Push Body Test').call
      end

      expect(@response.errors.present?).to be_truthy
      expect(@response.errors.last.options[:message]).to eq(I18n.t('jera_push.services.errors.not_found.device'))
    end
  end

end
