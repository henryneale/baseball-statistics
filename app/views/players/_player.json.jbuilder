json.extract! player, :id, :name, :avg, :hr, :rbi, :runs, :sb, :ops, :created_at, :updated_at
json.url player_url(player, format: :json)
