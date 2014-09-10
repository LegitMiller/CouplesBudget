json.array!(@envelopes) do |envelope|
  json.extract! envelope, :id, :name, :color, :icon, :precent, :cash, :user_id
  json.url envelope_url(envelope, format: :json)
end
