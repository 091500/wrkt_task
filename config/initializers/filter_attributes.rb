module FilteredSQLLogger
  def debug(message = nil)
    return unless message
    filtered = message.gsub(/'(?:[^']*@[a-zA-Z0-9.-]+)'/, "'[FILTERED]'") # hide emails
    super(filtered)
  end
end

ActiveRecord::LogSubscriber.prepend(FilteredSQLLogger)
