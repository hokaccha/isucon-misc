require 'sinatra'
require 'yaml'
require './query_summarizer'
require './access_summarizer'
require './slow_query_summarizer'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  @query_summary = QuerySummarizer.new(config['query_log']).summarize
  @access_summary = AccessSummarizer.new(config['access_log']).summarize
  @slow_query_summary = SlowQuerySummarizer.new(config['slow_query_log']).summarize
  erb :index
end

def config
  @config ||= YAML.load_file('config.yml')
end

helpers do
  def format(ms)
    "#{(ms * 1000).round(2)}ms"
  end
end
