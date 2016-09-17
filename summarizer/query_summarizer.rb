require 'json'

class QuerySummarizer
  def initialize(config)
    @filepath = config['filepath']
    @root_dir = config['root_dir']
  end

  def summarize
    File.readlines(@filepath)
      .map { |line|
        next if line.strip[0] == '#'
        begin
          JSON.parse(line.chomp, symbolize_names: true)
        rescue JSON::ParserError => err
          $stderr.puts err
          nil
        end
      }
      .compact
      .inject({}) { |memo, line|
        sql = line[:sql]
        caller = line[:caller].sub("#{@root_dir}/", '')
        memo[sql] ||= { sql: sql, callers: [], durations: [] }
        memo[sql][:callers] << caller
        memo[sql][:durations] << line[:duration]
        memo
      }
      .map { |_, line|
        line[:callers].uniq!
        line.merge(aggregate(line[:durations]))
      }
  end

  def aggregate(durations)
    count = durations.size
    sum = durations.reduce(&:+)

    {
      count: count,
      sum: sum,
      average: sum / count,
      max: durations.max,
      min: durations.min,
    }
  end
end
