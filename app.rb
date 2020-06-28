require_relative 'time_service'

class App

  def call(env)
    request = Rack::Request.new(env)

    params = if request.path_info == '/time'
               request_time(request.params)
             else
               request_404
             end

    Rack::Response.new(*params).finish
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def request_404
    [["Page not found."], 404, headers]
  end

  def request_time(params)
    time = TimeService.new(params)
    body = [time.result.join("\n") + "\n\n"]

    if time.success?
      [body, 200, headers]
    else
      [body, 400, headers]
    end
  end
end
