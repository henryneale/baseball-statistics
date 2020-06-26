# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'crack'
require 'crack/xml'

def parseXml(xml)
  table_data = []
  xml["SEASON"].values_at("LEAGUE").each do |division|
    division.each do |specific_division|
      specific_division["DIVISION"].each do |division_sector|
        division_sector["TEAM"].each do |team|
          team["PLAYER"].each do |player|
            name = "#{player["GIVEN_NAME"]} #{player["SURNAME"]}"
            avg = player["HITS"].to_f / player["AT_BATS"].to_f unless player["AT_BATS"].to_f == 0
            home_runs = player["HOME_RUNS"].to_i
            rbi = player["RBI"].to_i
            runs = player["RUNS"].to_i
            steals = player["STEALS"].to_i
            times_on_base = (player["HITS"].to_f + player["WALKS"].to_f + player["HIT_BY_PITCH"].to_f)
            plate_appearances = (player["AT_BATS"].to_f + player["WALKS"].to_f + player["SACRIFICE_FLIES"].to_f + player["HIT_BY_PITCH"].to_f)
            obp = times_on_base / plate_appearances unless plate_appearances == 0
            slg = (player["DOUBLES"].to_f * 2 + player["TRIPLES"].to_f * 3 + player["HOME_RUNS"].to_f * 4 + (player["HITS"].to_f - player["DOUBLES"].to_f - player["TRIPLES"].to_f - player["HOME_RUNS"].to_f)) / player["AT_BATS"].to_f unless player["AT_BATS"].to_f == 0
            ops = obp + slg unless obp == nil || slg == nil
            table_data.push({name: name, avg: avg.to_f.round(3), hr: home_runs, rbi: rbi, runs: runs, sb: steals, ops: ops.to_f.round(4)})
          end
        end
      end
    end
  end
  table_data
end

file = File.join(Rails.root, 'app', '1998statistics.xml')
response = Crack::XML.parse(File.read(file))
players = parseXml(response)

players.each do |player| 
  Player.create(name: player[:name], avg: player[:avg], hr: player[:hr], rbi: player[:rbi], runs: player[:runs], sb: player[:sb], ops: player[:ops])
end
