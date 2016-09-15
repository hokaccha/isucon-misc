require 'logger'
require 'json'

module Mysql2QueryLogger
  def self.enable!(file = '/tmp/query.log')
    Mysql2::Client.prepend(Mysql2QueryLogger::ClientMethods)
    Mysql2::Statement.prepend(Mysql2QueryLogger::StatementMethods)

    @logger = Logger.new(file)
    @logger.formatter = proc { |severity, datetime, progname, message|
      message.to_json + "\n"
    }
  end

  def self.execute(sql)
    file, line = parse_caller caller[1]

    start = Time.now
    result = yield
    duration = Time.now - start

    @logger.info(sql:sql, file: "#{file}:#{line}", duration: duration)

    result
  end

  def self.parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      file = $1
      line = $2.to_i
      method = $3
      [file, line, method]
    end
  end

  module ClientMethods
    def prepare(sql)
      super.tap { |stmt| stmt.instance_variable_set(:@_sql, sql) }
    end

    def query(sql, options = {})
      Mysql2QueryLogger.execute(sql) { super }
    end
  end

  module StatementMethods
    def execute(*args)
      Mysql2QueryLogger.execute(@_sql) { super }
    end
  end
end
