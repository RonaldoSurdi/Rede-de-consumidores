json.array!(@cities) do |city|
  json.extract! city, :description, :uf
  json.url city_url(city, format: :json)
end
