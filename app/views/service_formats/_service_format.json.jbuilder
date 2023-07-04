json.extract! service_format, :id, :service_id, :version, :active, :current, :created_at, :updated_at
json.url service_format_url(service_format, format: :json)
