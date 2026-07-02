# frozen_string_literal: true

class RestWrapper
  attr_accessor :url, :login, :password

  def initialize(url:, login:, password:)
    @url = url
    @login = login
    @password = password
  end

  def get(current_url, _params = {})
    response = RestClient::Request.execute method: :get,
                                           url: compile_full_url(current_url),
                                           user: login,
                                           password: password,
                                           accept: 'application/json',
                                           headers: { content_type: 'application/json' }
    real_status = response.code
    json_response = JSON.parse(response)
    json_status = if json_response.is_a?(Array)
                json_response.first['status']
              else
                json_response['status']
              end
    if json_status == real_status || json_status.nil?
      JSON.parse(response)
      
    else
      message =  $logger.info("Статусы от сервера и в теле не совпадают. Статус от сервера:#{real_status} Статус в теле :#{json_status}")
      JSON.parse(response)
    end
    rescue StandardError => e
    send_error e
  end

  def post(current_url, params = {})
    response = RestClient::Request.execute method: :post,
                                           url: compile_full_url(current_url),
                                           user: login,
                                           password: password,
                                           payload: params.to_json,
                                           headers: { content_type: 'application/json' }
    JSON.parse(response)
  rescue StandardError => e
    send_error e
  end

  def put(current_url, params = {})
    response = RestClient::Request.execute method: :put,
                                           url: compile_full_url(current_url),
                                           user: login,
                                           password: password,
                                           payload: params.to_json,
                                           headers: { content_type: 'application/json' }
    JSON.parse(response)
  rescue StandardError => e
    send_error e
  end

  def delete(current_url, params = {})
    response = RestClient::Request.execute method: :delete,
                                           url: compile_full_url(current_url),
                                           user: login,
                                           password: password,
                                           payload: params.to_json,
                                           headers: { content_type: 'application/json' }
    JSON.parse(response)
  rescue StandardError => e
    send_error e
  end

  private

  def send_error(exception)
    puts exception.inspect
    body = exception.response.body
   # puts body
    raise_message = if body.class == String
                      "Ошибка #{exception.response.code} с текстом #{JSON.parse(body)}"
                    else
                      "Ошибка #{exception}"
                    end
    raise raise_message
  end

  def compile_full_url(current_url)
    url + current_url
  end
end
