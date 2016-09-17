methods = %w(get post put patch delete head options)
re = /^(#{Regexp.union(methods)})\s+(.+)\s+do$/

File.readlines(ARGV[0]).each do |line|
  match = re.match(line.strip)
  next unless match
  puts "#{match[1]}: #{match[2]}"
end
