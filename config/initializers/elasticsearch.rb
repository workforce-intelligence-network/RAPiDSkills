if Rails.env.production?
  # Needed for Review apps since can't set ELASTICSEARCH_URL on the fly
  ENV["ELASTICSEARCH_URL"] = ENV["BONSAI_URL"]
end
