require "spec_helper"
require "commuter"

describe "Commutes" do
    commuters = CsvHashConverter.new("./data/gschool_commute_data.csv").csv_to_hash
    commuters = Commutes.new(commuters).sort_by_week_and_weekday
  it "Can give a commuter's time" do
    commuter = "Nate"
    week = "4"
    weekday = "Wednesday"
    route = "Inbound"

    expect(commuters.find_commute_time(commuter, week, weekday, route)).to eq(100)
  end

  it "Can give the group average commute time" do
    expect(commuters.average_commute).to eq(37.54)
  end
end