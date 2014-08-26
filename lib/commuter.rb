require "csv"
require "pp"
require "date"

def nate_wed_inbound(name, day)
  if name == "Nate" && day["Week"] == "4" && day["Day"] == "Wednesday"
    puts "Nate's Wed Inbound: " + day["Inbound"]
  end
end

commuters = {}
ordered_weekdays = Date::DAYNAMES

CSV.foreach("./data/gschool_commute_data.csv", :headers => true) do |row|
  if commuters.keys.include?(row.fields[0])
    commuters[row.fields[0]] << Hash[row.headers[1..-1].zip(row.fields[1..-1])]
  else
    commuters[row.fields[0]] = []
    commuters[row.fields[0]] << Hash[row.headers[1..-1].zip(row.fields[1..-1])]
  end
end

commuters.values.each do |commuter_data|
  commuter_data.each { |commute| commute["Weekday"] = ordered_weekdays.index(commute["Day"]) }
  commuter_data.sort_by! { |commute| [commute["Week"], commute["Weekday"]] }
  commuter_data.each { |commute| commute.delete("Weekday") }
end

commuters.each do |name, commutes|
  commutes.each do |day|
    nate_wed_inbound(name, day)
  end
end

total_time = 0
commute_count = 0
commuters.values.each do |commutes|
  commutes.each do |day|
    total_time += (day["Inbound"].to_i + day["Outbound"].to_i)
    commute_count += 2
  end
end

puts "Average Commute: " + (total_time.to_f / commute_count).to_s

walks = []
commuters.each do |name, commutes|
  commutes.each do |day|
    if day["Mode"] == "Walk"
      walks << {name => day["Inbound"]}
    end
  end
end

fastest_walker = walks.uniq.sort_by! {|walk| walk.values }.first
puts "Fastest Walker: " + fastest_walker.keys[0] + " - " + fastest_walker.values[0]

speeds = []
commuters["Emily"].each do |commute|
  if commute["Mode"] == "Walk"
    speeds << (commute["Distance"].to_f / commute["Inbound"].to_f)
  end
end

puts speeds.reduce(:+)/speeds.length