require 'test_helper'

class Ai::ChatStreamerTest < ActiveSupport::TestCase
  test 'should return error if question is blank' do
    called = false

    writer = Object.new
    writer.define_singleton_method(:error) do |msg|
      called = (msg == 'Question cannot be blank.')
    end

    chat = Object.new

    streamer = Ai::ChatStreamer.new(
      question: '   ',
      writer: writer,
      chat: chat
    )

    streamer.call

    assert called
  end

  test 'should stream chat response' do
    chunks = []
    done_called = false

    writer = Object.new
    writer.define_singleton_method(:chunk) { |chunk| chunks << chunk }
    writer.define_singleton_method(:done) { done_called = true }

    chat = build_chat(['Chunk 1', 'Chunk 2'])

    streamer = Ai::ChatStreamer.new(
      question: 'What is AI?',
      writer: writer,
      chat: chat
    )

    streamer.call

    assert_equal ['Chunk 1', 'Chunk 2'], chunks
    assert done_called
  end

  private

  def build_chat(chunks = [])
    Object.new.tap do |c|
      c.define_singleton_method(:stream) do |_question, &block|
        chunks.each { |chunk| block.call(chunk) }
      end
    end
  end
end
