module Ai
  class ChatStreamer
    def initialize(question:, writer:, chat:)
      @question = question.to_s.strip
      @writer = writer
      @chat = chat
    end

    def call
      return writer.error('Question cannot be blank.') if question.blank?

      chat.stream(question) do |chunk|
        writer.chunk(chunk)
      end

      writer.done
    end

    private

    attr_reader :question, :writer, :chat
  end
end
