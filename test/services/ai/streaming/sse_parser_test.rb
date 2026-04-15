require 'test_helper'

class Ai::Streaming::SseParserTest < ActiveSupport::TestCase
  test 'should parses SSE chunks correctly' do
    parser = Ai::Streaming::SseParser.new

    chunks = []
    data = "data: {\"candidates\":[{\"content\":{\"parts\":[{\"text\":\"Hello\"}]}}]}\n\n"

    parser.call(data) do |parsed|
      chunks << parsed
    end

    assert_equal 1, chunks.size
  end

  test 'should handle incomplete chunks' do
    parser = Ai::Streaming::SseParser.new

    chunks = []
    data1 = "data: {\"candidates\":[{\"content\":{\"parts\":[{\"text\":\"Hello\"}]}}]}\n"
    data2 = "\n"

    parser.call(data1) do |parsed|
      chunks << parsed
    end

    parser.call(data2) do |parsed|
      chunks << parsed
    end

    assert_equal 1, chunks.size
  end
end
