Model.new(:production, "IPBOX") do
  database PostgreSQL do |db|
    db.name     = "ipbox_production"
    db.username = ENV.fetch("POSTGRES_USER", "postgres")
    db.password = ENV.fetch("POSTGRES_PASSWORD", nil)
    db.host     = ENV.fetch("POSTGRES_HOST", "postgres")
    db.port     = ENV.fetch("POSTGRES_PORT", "5432")
  end

  compress_with Gzip

  store_with FTP do |server|
    server.username     = ENV["BACKUP_FTP_USERNAME"]
    server.password     = ENV["BACKUP_FTP_PASSWORD"]
    server.ip           = ENV["BACKUP_FTP_ADDRESS"]
    server.port         = ENV["BACKUP_FTP_PORT"]
    server.path         = ENV["BACKUP_FTP_PATH"].dup
    server.keep         = ENV["BACKUP_FTP_KEEP"].to_i
    server.passive_mode = ENV["BACKUP_FTP_PASSIVE_MODE"] == "true"
  end
end
