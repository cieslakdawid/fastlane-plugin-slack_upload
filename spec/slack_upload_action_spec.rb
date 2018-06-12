describe Fastlane::Actions::SlackUploadAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The slack_upload plugin is working!")

      Fastlane::Actions::SlackUploadAction.run(nil)
    end
  end
end
