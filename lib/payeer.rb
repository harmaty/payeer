require 'net/https'
require 'logger'

class Payeer
  API_URL = 'https://payeer.com/ajax/api/api.php'

  class AuthError < Exception
  end

  class ApiError < Exception
  end

  attr_accessor :account, :api_id, :api_secret, :config, :logger

  DEFAULTS = {
      language: 'ru'
  }

  def initialize(account, api_id, api_secret, options = {})
    @account = account
    @api_id = api_id
    @api_secret = api_secret
    @config = DEFAULTS.merge(options)
    @logger = Logger.new @config[:log] ? STDOUT : nil
  end

  def balance
    api_call action: 'balance'
  end

  def transaction_history(transaction_id)
    response = api_call action: 'historyInfo', historyId: transaction_id
    if response['info'].is_a? Hash
      response['info']
    end

  end

  def transfer_funds(options = {})
    payload = {
        'action' => 'transfer',
        'curIn' => options[:currency_from] || 'USD',
        'sum' => options[:amount],
        'curOut' => options[:currency_to] || 'USD',
        'to' => options[:to],
        'comment' => options[:comment],
    }
    payload['anonim'] = options[:anonim] if options[:anonim]
    payload['protect'] = options[:protect] if options[:protect]
    payload['protectPeriod'] = options[:protectPeriod] if options[:protectPeriod]
    payload['protectCode'] = options[:protectCode] if options[:protectCode]
    response = api_call payload
    response['historyId']
  end

  def api_call(options = {})
    uri = URI API_URL
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(prepare_params(options))
    logger.info "Payeer API Request url: #{uri}, payload: #{prepare_params(options)}"
    response = http.request(request)
    json_response = JSON.parse(response.body)
    logger.info "Payeer API Response: #{json_response.inspect}"

    raise AuthError if json_response["auth_error"].to_i > 0
    raise ApiError, json_response["errors"].inspect if json_response["errors"] && json_response["errors"].any?
    json_response
  end

  def prepare_params(params)
    auth = {
        account: account,
        apiId: api_id,
        apiPass: api_secret,
        lang: config[:language]
    }
    params.merge(auth)
  end

end