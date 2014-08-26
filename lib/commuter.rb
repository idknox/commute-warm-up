require "date"
require "csv_to_hash_converter"

class Commutes
  def initialize(commuters)
    @commuters = commuters
  end

  def sort_by_week_and_weekday
    ordered_weekdays = Date::DAYNAMES
    @commuters.values.map do |commuter_data|
      commuter_data.each { |commute| commute["Weekday"] = ordered_weekdays.index(commute["Day"]) }
      commuter_data.sort_by! { |commute| [commute["Week"], commute["Weekday"]] }
      commuter_data.each { |commute| commute.delete("Weekday") }
    end
    self
  end

  def find_commute_time(commuter, week, weekday, route)
    output = []
    @commuters.each do |name, commutes|
      commutes.each do |day|
        if name == commuter && day["Week"] == week && day["Day"] == weekday
          output << day[route]
        end
      end
    end
    output.first.to_i
  end

  def average_commute
    total_time = 0
    commute_count = 0
    @commuters.values.each do |commutes|
      commutes.each do |day|
        total_time += (day["Inbound"].to_i + day["Outbound"].to_i)
        commute_count += 2
      end
    end
    (total_time.to_f / commute_count).round(2)
  end

  def fastest_by_mode(mode, route)
    commutes = []
    @commuters.each do |name, commute_data|
      commute_data.each do |day|
        if day["Mode"] == mode
          commutes << [name, day[route]]
        end
      end
    end
    commutes.uniq.sort_by! { |commute| commute[1] }.first[0]
  end

  def average_of_fastest(mode, route)
    speeds = []
    fastest = fastest_commuter_by_mode(mode, route)
    @commuters[fastest].each do |commute|
      if commute["Mode"] == mode
        speeds << (commute["Distance"].to_f / commute[route].to_f)
      end
    end
    speeds.reduce(:+)/speeds.length
  end
end