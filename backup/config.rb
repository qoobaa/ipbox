Dir[File.join(File.dirname(Config.config_file), "models", "*.rb")].each do |model|
  instance_eval(File.read(model))
end
