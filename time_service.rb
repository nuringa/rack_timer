class TimeService

  TIME_FORMATS = {
      'year' => '%Y',
      'month' => '%m',
      'day' => '%d',
      'hour' => '%H',
      'minute' => '%M',
      'second' => '%S'
  }.freeze

  def initialize(request_params)
    @formats = request_params['format'] ? request_params['format'].split(',') : []
  end

  def success?
    @formats.any? && unrecognized.empty?
  end

  def result
    if success?
      [Time.now.strftime(time_params)]
    elsif unrecognized.any?
      ["Unknown time format [#{@unknown_formats.join(", ")}]"]
    else
      ["Received no time formats. Pls use '/time?format=year%2Cmonth%2Cday' pattern"]
    end
  end

  private

  def time_params
    TIME_FORMATS.values_at(*@formats).join('-')
  end

  def unrecognized
    @unknown_formats = @formats - TIME_FORMATS.keys
  end
end
