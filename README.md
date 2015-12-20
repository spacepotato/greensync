# GreenSync Coding Exercise

## My Notes

(Notes are broken down into bulleted list to line up with individual tasks)

1. This task was quite simple, and only required changing the year to 2013 in the fetch-data script.
   This could be extended by taking in an argument which is the year that you want to fetch data for, 
   eg: year = ARGV[0] 
   But as it was such a minor part of the task I settled for simply hard-coding the year

2. This was the hardest part of the task I found and I completed it in two sections. I first attempted
   to improve the performance of actually fetching the data. It took me a while, but the real a-ha moment was
   realising that the original method of fetching was inefficient due to the need to check every existing element of the
   array upon inserting new data. Realising that this functionality would be much better suited to a hash I made the decision 
   to change the underlying data structure, which saw a decent increase in the loading of data. 

   My initial hash was a simple replacement of the 2d array, eg Hash[timestamp] = value. But this still left us subject to the
   inefficiencies in the processing of data. I initially experimented with adjusting the existing methods in time_series to improve
   efficiency, but these adjustments made only minor differences to the runtime speed. This was when I made the major decision to make the trade-off
   between space and time shift in favour of time. My implementation of a large hash structure of the form:
   ```
    Hash[year][:months][month][:days][day]
   ```
   (where year, month and day are variables corresponding to the date in question)
   saw huge speed improvements as we have effectively swapped to an O(n) insert and O(1) output to CSV. While you could argue that it is important to balance
   space and time as much as possible, I feel that in this project, memory will rarely be an issue while speed is listed as being a high priority. 

   The change to a hash structure also required me to remove quite a few methods that were no longer required (eg We no longer needed to get last_timestamp as we
   pre-processed the data) and due to this I also reduced the number of tests. That being said, the code coverage of tests was still %92, with the only omittance being
   DataLoader#load_series

3. This was another easy task that simply required adding a period attribute to the CSV file and then appending "day" to each row pushed to the CSV file

4. The Hash that I talked about in (2) is the final format of the Hash, which was heavily influenced by the requirements of this task. For each year and month, I stored
   the values that needed to be outputted:
   ```
   Hash[2015] => {min: 12, max: 200, sum: 1200, count: 5, months: {}} 
   ```
   which made it quite simple to actually output the data. 

5. Unfortunately I didn't have enough time to complete this part of the project (I capped myself at ~2:30 hours) as it took me a little bit longer than it should have to determine
   the final structure for the Hash. If I had the time I would have implemented this part of the project by adding an additional hash that would store {timestamp => value} thus allowing us 
   to calculate the median, variance and std. deviation. 

As well as (5) had I had more time I would have spent a bit of time refactoring TimeSeries as the name is no longer particularly indicitive of its purpose. I would also change how I was handling
the 00:00 timestamp as I felt that my solution was a bit hacky due to time constraints. 

## Background

Greentastic Electricity Supply Concern is looking to expand into retail electricity price
trading.  As a start, they're looking to do some analysis on previous price data.  To begin with,
they were looking for the minimum, maximum and average retail price of electricity in Victoria.
They're now looking to expand that analysis, with more data, and more in-depth statistics.

This codebase represents the first version, and contains the 2014 data.  It works, but it's far
too slow; and the new features need to be built.

## The exercise

Most of the tasks focus on the daily-stats script, and its operation, except the first one.

For all of these tasks, give a short summary of the decisions taken and the changes made, and your
motivations for them.  Submit your solution as a git repo.

The task should take at most a few hours.

1. Get the 2013 data using script/fetch-data.

2. Improve the performance of the daily stats generator -- it should probably be an
   order-of-magnitude faster.  Currently it takes around three minutes to process 12 months
   worth of data on the machines that G.E.S.C. is using.

3. Add a column that describes the time period the statistic relates to ("day" for the current
   version).

4. Add a row at the start of every month that calculates the statistics for that month (time
   period = "month"), and a row at the start of every year which has the statistics for that
   year (time period = "year").  Just use the date of the first day as the date.

5. If you have the time, add the median, variance and standard deviation.  (median_rrp,
   rrp_variance, rrp_standard_deviation)

## Example output

```
period,date,min_rrp,max_rrp,average_rrp
year,2014-01-01,-14863,597227,4162
month,2014-01-01,-2570,597227,7243
day,2014-01-01,-267,4560,3695
day,2014-01-02,3658,4868,4392
day,2014-01-03,3904,4711,4408
day,2014-01-04,3820,4668,4279
day,2014-01-05,3676,4515,4046
day,2014-01-06,3406,4573,4272
```

## Getting it running.

- It uses Bundler and has a .ruby-version -- so RVM or rbenv or equivalent should get you going.
- To run the tests, just run "rake"
- To run the script that generates the output data, run "script/daily-stats".  The CSV is
  generated to stdout.
- There is another script, "script/fetch-data" that will re-fetch the data from the AEMO website.

## Notes

- The data are all in UTC+10 -- there is no daylight savings; the code treats them as UTC as a
  shortcut to dealing with them properly.
- As with most electricity metering data, the timestamps are the *end* of the time period they're
  covering -- i.e. 13:30 represents the time period from 13:00 to 13:30.  (Strictly speaking it
  doesn't actually include 13:30:00, but all the time leading up to it.)  So to get the price at a
  given time, you round up to the nearest half hour -- e.g. 15:11 rounds up to 15:30, so that's
  the row that corresponds.

## Copyright

Copyright (c) 2015 GreenSync Pty Ltd.  All rights reserved.

