class SseWriter
  def initialize(stream)
    @stream = stream
  end

  def chunk(content)
    write(type: 'chunk', content: content)
  end

  def error(message)
    write(type: 'error', content: message)
  end

  def done
    write(type: 'done')
  end

  private

  attr_reader :stream

  def write(payload)
    stream.write("data: #{payload.to_json}\n\n")
  end
end
