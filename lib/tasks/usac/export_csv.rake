require 'csv'

namespace :usac do
  desc 'grabs results and exports to a csv'
  task crossresults: :environment do
    # parse USAC race identifiers in the command line
    # https://cobwwweb.com/4-ways-to-pass-arguments-to-a-rake-task
    ARGV.each { |a| task a.to_sym do ; end }.shift
    race_ids = ARGV
    raise "expecting only two race ids as boundaries" if race_ids.count > 2

    # set bounds for iteration
    bounds = race_ids[0]..race_ids[1]

    CSV.open("data/results.csv", "wb") do |csv|
      # append headers
      csv << ["Place", "Time", "First Name", "Last Name", "Team"]

      bounds.each do |race_id|
        response = Faraday.get("https://www.usacycling.org/API/race-results/?results_race_id=#{race_id}")
        puts "Something went wrong!" and return unless response.status == 200
        json = JSON.parse(response.body)
        puts "No results found with for race with id #{race_id}" and return unless json.present?
        puts "Results found for race with id #{race_id}"


        sample = json.first
        category = sample["category"]
        gender = case sample["gender"]
        when 'M'
          'Men'
        when 'F'
          'Women'
        end
        age = sample["age"]
        klass = sample["class"]

        category_name = "#{gender} #{klass} #{age} #{category}".split.join(" ")

        # append new line
        csv << []
        # append category
        csv << [category_name]

        json.each do |result|
          place = result["place"]
          time = result["time"]
          first = result["first"]
          last = result["last"]
          team = result["team"].empty? ? nil : result["team"]
          csv << [place, time, first, last, team] unless place == "996" # 996 is code for DNS
        end

        puts "Finished exporting results for #{category_name}"
      end
    end
  end
end
