# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

class DailyStats

  def initialize(time_series)
    @time_series = time_series.data
    @period = "day"
  end

  def each
    return if @time_series.nil?

    @time_series.each do |year, yearly_stats|
      yield "year", "#{year}", yearly_stats[:min], yearly_stats[:max], (yearly_stats[:sum]/yearly_stats[:count].to_f).round
      @time_series[year][:months].each do |month, monthly_stats|
        yield "month", "#{year}-#{month.to_s.rjust(2, '0')}", monthly_stats[:min], monthly_stats[:max], (monthly_stats[:sum]/monthly_stats[:count].to_f).round
        @time_series[year][:months][month][:days].each do |day, stats_hash|
          yield "day", "#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}", stats_hash[:min], stats_hash[:max], (stats_hash[:sum]/stats_hash[:count].to_f).round
        end
      end
    end
  end
end