require 'spec_helper'

RSpec.describe 'DSL - Messages' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }

  describe '#messages' do
    before do
      stub_fetch_request(endpoint: %r{/messages}, response_body: [{ id: 42 }, { id: 43 }])
    end

    it 'returns a collection of messages' do
      messages = client.messages
      expect(messages).to be_instance_of FidorApi::Collection

      message = messages.first
      expect(message).to be_instance_of FidorApi::Model::Message
      expect(message.id).to eq 42
    end
  end

  describe '#message' do
    before do
      stub_fetch_request(endpoint: %r{/messages/42}, response_body: { id: 42 })
    end

    it 'returns the message object' do
      message = client.message 42
      expect(message).to be_instance_of FidorApi::Model::Message
      expect(message.id).to eq 42
    end
  end

  describe '#message_attachment' do
    before do
      stub_fetch_request(
        endpoint:         %r{/messages/42/attachment},
        response_body:    'binary-data',
        response_headers: {
          'Content-Type'        => 'application/pdf',
          'Content-Disposition' => 'attachment; filename="filename.pdf"'
        }
      )
    end

    it 'downloads the attached file' do
      attachment = client.message_attachment 42
      expect(attachment).to be_instance_of FidorApi::Model::Message::Attachment
      expect(attachment.type).to     eq 'application/pdf'
      expect(attachment.filename).to eq 'filename.pdf'
      expect(attachment.content).to  eq 'binary-data'
    end
  end

  describe '#message_content' do
    before do
      stub_fetch_request(
        endpoint:         %r{/messages/42/content},
        response_body:    'binary-data',
        response_headers: {
          'Content-Type' => 'application/pdf'
        }
      )
    end

    it "returns message's binary content" do
      content = client.message_content 42
      expect(content).to be_instance_of FidorApi::Model::Message::Content
      expect(content.raw).to eq 'binary-data'
    end
  end
end
