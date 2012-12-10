ZnTestbed::Application.config.middleware.insert 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any,
                  methods: [:get, :post, :put, :delete, :options]
  end
end
