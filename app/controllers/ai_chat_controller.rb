class AiChatController < ApplicationController
  include ActionController::Live

  before_action :set_response_headers
  rate_limit to: 20, within: 1.day, scope: :ip, with: :over_limit

  def stream
    question = params[:question].to_s.strip
    chat = Ai::Chat.new

    if question.blank?
      write_sse(type: 'error', content: 'Question cannot be blank.')
      return
    end

    chat.stream(question) do |chunk|
      write_sse(type: 'chunk', content: chunk)
    end

    write_sse(type: 'done')
  rescue IOError
    write_sse(type: 'error', content: 'Connection closed.')
  rescue StandardError
    write_sse(type: 'error', content: 'Internal server error.')
  ensure
    response.stream.close
  end

  private

  def set_response_headers
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['X-Accel-Buffering'] = 'no'
  end

  def write_sse(payload)
    response.stream.write("data: #{payload.to_json}\n\n")
  end

  def over_limit
    redirect_to about_path, alert: t('alert.over_limit')
  end
end
