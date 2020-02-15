json.app do
  json.id @app.package_id
  json.name @app.name
  json.author @app.author
  json.versions do
    json.array!(@app.version.order('created_at DESC'), :name, :define_url)
  end
end