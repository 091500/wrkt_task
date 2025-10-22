if Rails.env.test?
  APILogger = Logger.new(nil)
else
  balance_logfile = Rails.root.join("log", "api_#{Rails.env}.log")

  APILogger = Logger.new(balance_logfile)
  APILogger.level = Logger::INFO
  APILogger.formatter = proc do |severity, datetime, _progname, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
  end
end
