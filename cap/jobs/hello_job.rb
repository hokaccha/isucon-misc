class HelloJob
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform(message)
    puts "hello #{message}"
  end
end
