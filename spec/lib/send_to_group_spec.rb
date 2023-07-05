require 'rails_helper'

describe 'Enviar uma mensagem para um grupo de usuarios' do
  before(:each) do
    @users = FactoryBot.create_list(:user, 10)

    @users.each { |user| user.devices.create(token: Faker::Crypto.sha256) }
  end

  context 'enviar mensagem para todos os usuarios' do
    it 'uma nova mensagem é enviada para todos da aplicação' do
      VCR.use_cassette('firebase_send_single_push', allow_playback_repeats: true) do
        @response = JeraPush::Services::Message::SendToEveryoneService.new(title: 'Push Title Test', body: 'Push Body Test').call
      end

      expect(@response.success_count.positive?).to be_truthy
      expect(@response.failure_count.zero?).to be_truthy
    end
  end

  context 'enviar mensagem para todos os usuarios android' do
    it 'uma nova mensagem é enviada para todos usuario android' do
      VCR.use_cassette('firebase_send_single_push', allow_playback_repeats: true) do
        @response = JeraPush::Services::Message::SendToTopicService.new(title: 'Push Title Test', body: 'Push Body Test', topic: 'topic_android').call
      end

      expect(@response.kind).to eq('topic')
      expect(@response.success_count.positive?).to be_truthy
      expect(@response.failure_count.zero?).to be_truthy
    end
  end

  context 'enviar mensagem para todos os usuarios ios' do
    it 'uma nova mensagem é enviada para todos ios' do
      VCR.use_cassette('firebase_send_single_push') do
        @response = JeraPush::Services::Message::SendToTopicService.new(title: 'Push Title Test', body: 'Push Body Test', topic: 'topic_ios').call
      end

      expect(@response.kind).to eq('topic')
      expect(@response.success_count.positive?).to be_truthy
      expect(@response.failure_count.zero?).to be_truthy
    end
  end

end
