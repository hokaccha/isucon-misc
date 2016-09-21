class SlowQuerySummarizer

  COUNT_REGEXP = /Count: (\d+)/
  TIME_REGEXP = /Time=([\d|\.]+)s \((\d+)s\)/
  LOCK_REGEXP = /Lock=([\d|\.]+)s \((\d+)s\)/
  ROWS_REGEXP = /Rows=([\d|\.]+) \((\d+)\)/

  def initialize(config)
    @filepath = config['filepath']
  end

  def summarize
    File.readlines(@filepath)
      .slice_before { |line| line.start_with?("Count:") }
      .map { |lines|
        result = analyze_line(lines.first)
        result[:sql] = lines[1..-1].join(" ").strip
        result
      }
  end

  private

  def analyze_line(line)
    return {} unless line
    result = {}
    result[:count] = line.match(COUNT_REGEXP)[1].to_i
    result[:average] = line.match(TIME_REGEXP)[1].to_f
    result[:sum] = line.match(TIME_REGEXP)[2].to_f
    result[:lock_average] = line.match(LOCK_REGEXP)[1].to_f
    result[:lock_sum] = line.match(LOCK_REGEXP)[2].to_f
    result[:rows_average] = line.match(ROWS_REGEXP)[1].to_f
    result[:rows_sum] = line.match(ROWS_REGEXP)[2].to_i
    result
  end

end
