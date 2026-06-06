#require time to get the current timestamp with the same formate as requried in the task
require "time"

module Logger
  def log_info(message)
    write_to_file("info", message)
  end

  def log_warning(message)
    write_to_file("warning", message)
  end

  def log_error(message)
    write_to_file("error", message)
  end

  private

  def write_to_file(log_type, message)
    timestamp = Time.now.iso8601
    log_line = "#{timestamp} -- #{log_type} -- #{message}\n"

    File.open("app.log", "a") do |file|
      file.write(log_line)
    end
  end
end
