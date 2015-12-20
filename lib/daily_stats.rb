# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

class DailyStats

  def initialize(time_series)
    @time_series = time_series
  end

  def values(midnight)
    (1..48).map do |interval|
      @time_series[midnight + interval * 30 * 60]
    end
  end

  def min_max_avg(midnight)
    values = values(midnight)

    [values.min, values.max, (values.inject(&:+) / values.length.to_f).round]
  end

  def each
    midnight = @time_series.first_timestamp - 30 * 60

    while midnight < @time_series.last_timestamp
      yield midnight, *min_max_avg(midnight)
      midnight += 24 * 60 * 60
    end
  end
end