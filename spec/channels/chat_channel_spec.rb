
require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:current_user) { 'test' }

  before do
    stub_connection current_user: current_user
    subscribe
  end

  describe '#subscribed' do
    it "streams messages from my_channel" do
      expect(subscription).to be_confirmed
      expect(streams).to include('my_channel')
    end
  end

  describe '#send_message' do
    let(:body) { 'hello' }

    it "re-broadcasts to my_channel" do
      expect {
        perform :send_message, message: { body: body }
      }.to have_broadcasted_to('my_channel').with(sent_by: current_user, body: body)
    end
  end
end