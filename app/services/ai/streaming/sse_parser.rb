class Ai::Streaming::SseParser
  def initialize
    @buffer = +''
  end

  def call(chunk)
    @buffer << chunk

    while (line = @buffer.slice!(/.*\n/))
      line = line.strip
      next if line.blank?
      next unless line.start_with?('data:')

      payload = line.delete_prefix('data:').strip
      next if payload.blank?

      parsed = safe_parse(payload)
      yield parsed if parsed
    end
  end

  private

  def safe_parse(payload)
    JSON.parse(payload)
  rescue JSON::ParserError
    nil
  end
end
