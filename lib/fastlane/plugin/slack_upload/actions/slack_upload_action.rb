
module Fastlane
  module Actions
    class SlackUploadAction < Action
      def self.run(params)
        require 'slack-ruby-client'
        
        title = params[:title]
        filepath = params[:file_path]
        filename = params[:file_name]
        initialComment = params[:initial_comment]

        if params[:channel].to_s.length > 0 # From `slack` plugin implementation: https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/slack.rb
          channel = params[:channel]
          channel = ('#' + params[:channel]) unless ['#', '@'].include?(channel[0]) # send message to channel by default
        end

        if params[:file_type].to_s.empty?
          filetype = File.extname(filepath)[1..-1] # Remove '.' from the file extension
        else
          filetype = params[:file_type]
        end

        Slack.configure do |config|
          config.token = params[:slack_api_token]
        end

        client = Slack::Web::Client.new
        
        begin
          results = client.files_upload(
                    channels: channel,
                    as_user: true,
                    file: Faraday::UploadIO.new(filepath, filetype),
                    title: title,
                    filename: filename,
                    initial_comment: initialComment
                  )
        rescue => exception
          UI.error("Exception: #{exception}")
        ensure
          UI.success('Successfully sent file to Slack')
        end
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :slack_api_token,
                                       env_name: "SLACK_API_TOKEN",
                                       sensitive: true,
                                       description: "Slack API token"),
          FastlaneCore::ConfigItem.new(key: :title,
                                       env_name: "SLACK_UPLOAD_TITLE",
                                       description: "Title of the file",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :channel,
                                       env_name: "SLACK_UPLOAD_CHANNEL",
                                       description: "#channel or @username",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       env_name: "SLACK_UPLOAD_FILE_PATH",
                                       description: "Path to the file",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :file_type,
                                       env_name: "SLACK_UPLOAD_FILE_TYPE",
                                       description: "A file type identifier",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :file_name,
                                       env_name: "SLACK_UPLOAD_FILE_NAME",
                                       description: "Filename of file",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :initial_comment,
                                       env_name: "SLACK_UPLOAD_INITIAL_COMMENT",
                                       description: "Initial comment to add to file",
                                       optional: true)                  
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.description
        'Uploads given file to Slack'
      end

      def self.authors
        ['Dawid Cieslak']
      end

      def self.example_code
        [
          'slack_upload(
            title: "New version #{version} is available ",
            channel: "#general",
            file_path: "./screenshots.zip"
          )',
          'slack_upload(
            slack_api_token: "xyz", 
            title: "New version #{version} is available ",
            channel: "#general",
            file_path: "./screenshots.zip",
            file_type: "zip",                        # Optional, type can be recognized from file path,
            file_name: "screen_shots.zip",           # Optional, name can be recognized from file path,
            initial_comment: "Enjoy!"                # Optional
            )'
        ]
      end
    end
  end
end
