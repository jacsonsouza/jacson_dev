class AiChatController < ApplicationController
  include ActionController::Live

  before_action :set_response_headers, only: :stream
  rate_limit to: 20, within: 1.day, scope: :ip, with: :over_limit

  def stream
    writer = SseWriter.new(response.stream)
    ai_stream(writer)
  rescue IOError, Errno::EPIPE
    logger(message: 'Client disconnected.')
  rescue StandardError => e
    handle_stream_error(writer, e)
  ensure
    response.stream.close
  end

  private

  def set_response_headers
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['X-Accel-Buffering'] = 'no'
  end

  def ai_stream(writer)
    Ai::ChatStreamer.new(
      question: params[:question],
      writer: writer,
      chat: Ai::Chat.new
    ).call
  end

  def handle_stream_error(writer, error)
    logger(message: "Stream error: #{error.message}")
    writer&.error('Internal server error.')
  rescue IOError, Errno::EPIPE
    nil
  end

  def over_limit
    render json: { error: t('alert.over_limit') }, status: :too_many_requests
  end

  def logger(message:)
    Rails.logger.error("[AiChatController] #{message}")
  end
end
