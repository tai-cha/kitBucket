json.apps do
  json.array! @apps do |app|
    json.id app.package_id
    json.name app.name
  end
end