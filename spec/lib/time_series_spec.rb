# Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

require 'spec_helper'

describe TimeSeries do

  let(:series) { TimeSeries.new }

  context "after construction" do
    it "should be empty" do
      expect(series).to be_empty
    end
  end

  describe "#[]=" do
    let(:timestamp) { Time.now.utc }
    let(:value) { rand(123) }

    subject { series[timestamp] = value }

    context "into an empty series" do
      it "should make the series non-empty" do
        expect { subject }.to change { series.empty? }.from(true).to(false)
      end
    end

    context "into a series with timestamp existing" do
      let(:existing_value) { rand(123) + 123 }

      before do
        series[timestamp] = existing_value
      end

      it "should not change the emptiness" do
        expect { subject }.not_to change { series.empty? }
      end
    end
  end

  describe "#[]" do
    let(:timestamp) { Time.now.utc }
    let(:value) { rand(123) + 123 }

    before do
      (0..10).each { |t| series[Time.at(t).utc] = rand(123) }
      series[timestamp] = value
      (20..30).each { |t| series[Time.at(t).utc] = rand(123) }
    end

    subject { series[timestamp] }

    it "should return the value from the timestamp" do
      expect(subject[:sum]).to eq(value)
    end
  end
end