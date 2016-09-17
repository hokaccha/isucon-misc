require 'mustermann'

class AccessSummarizer
  def initialize(config)
    @filepath = config['filepath']
    @routes = config['routes'].map do |route|
      {
        method: route.keys[0].to_s.upcase,
        path: Mustermann.new(route.values[0]),
      }
    end
  end

  def summarize
    File.readlines(@filepath).map { |line|
      Hash[line.strip.split("\t").map{|f| f.split(":", 2)}]
    }
    .inject({}) { |memo, line|
      method, path = detect_route(line['method'], line['uri'])
      duration = line['apptime'] == '-' ? 0 : line['apptime'].to_f
      key = [method, path].join(':')

      memo[key] ||= { method: method, path: path, durations: [] }
      memo[key][:durations] << duration
      memo
    }
    .map { |_, line|
      line.merge(aggregate(line[:durations]))
    }
  end

  def detect_route(method, uri)
    method = method.upcase
    path = uri.split('?')[0]

    route = @routes.find do |r|
      method == r[:method] && r[:path] === path
    end

    [method, route ? route[:path].to_s : path]
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
