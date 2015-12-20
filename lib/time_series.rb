# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

class TimeSeries

  def initialize
    @data = {}
  end

  def data
    if !@data.empty?
      return @data
    else 
      return nil
    end
  end

  def empty?
    @data.empty?
  end

  def [](timestamp)
    return nil if empty?

    return @data[timestamp.year][:months][timestamp.month][:days][timestamp.day] rescue nil
  end

  def []=(timestamp, value)
    raise "timestamp must be a Time" unless timestamp.is_a?(Time)
    raise "timestamp must be UTC" unless timestamp.utc?

    unless value.nil?
      #Because we consider 00:00 to belong to the previous day
      if timestamp.strftime("%H:%M") == "00:00"
        timestamp -= 60
      end

      year = timestamp.year
      month = timestamp.month
      day = timestamp.day

      if !@data.has_key?(year)
        @data[year] = {min: nil, max: nil, count: 0, sum: 0, median: nil, deviation: nil, variance: nil, months: {}}
      end

      if !@data[year][:months].has_key?(month)
        @data[year][:months][month] = {min: nil, max: nil, count: 0, sum: 0, median: nil, deviation: nil, variance: nil, days: {}}
      end

      if !@data[year][:months][month][:days].has_key?(day)
        @data[year][:months][month][:days][day] = {min: nil, max: nil, count: 0, sum: 0, median: nil, deviation: nil, variance: nil}
      end

      stat_hashes = []

      #Yearly Stats
      stat_hashes.push(@data[year])

      #Monthly Stats
      stat_hashes.push(@data[year][:months][month])

      #Daily Stats
      stat_hashes.push(@data[year][:months][month][:days][day])

      stat_hashes.each do |update_hash|
        if update_hash[:min].nil? || value < update_hash[:min]
          update_hash[:min] = value
        end

        if update_hash[:max].nil? || value > update_hash[:max]
          update_hash[:max] = value
        end

        update_hash[:count] += 1
        update_hash[:sum] += value
      end

      return value
    end
  end

end