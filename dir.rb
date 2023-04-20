require "uri"
require "net/http"
require "cgi"
require "colorize"

THREAD_POOL_SIZE = 25
thread_pool = []

def scan_directory(url, dir, index, wordlist_size, valid_dirs, forbidden_dirs, not_found_dirs, mov_per)
  if dir.include?('%')
    target_url = "#{url.scheme}://#{url.host}:#{url.port}/#{dir}"
  else
    encoded_dir = URI::encode_www_form_component(dir).gsub('%2F', '/')
    target_url = "#{url.scheme}://#{url.host}:#{url.port}/#{encoded_dir}"
  end

  begin
    response = Net::HTTP.get_response(URI(target_url))
    if response.code == "200"
      valid_dirs << dir
      puts " | #{response.code} | #{target_url}".yellow
    elsif response.code == "403"
      forbidden_dirs << dir
    elsif response.code == "404"
      not_found_dirs << dir
    elsif response.code == "301"
      mov_per << dir
    else
      puts " Error (#{response.code}): #{target_url}".red
    end

  rescue URI::InvalidURIError => e
  rescue StandardError => e
    puts " Error: #{e.message}"
  end

  print "\rScanning... / #{index + 1}".blue
end

dirs = File.readlines("dicc.txt")
wordlist_size = dirs.size

print "Input Target Domain: "
domain = gets.chomp

unless domain.start_with?("http://") || domain.start_with?("https://")
  domain = "http://#{domain}"
end

url = URI.parse(domain)

valid_dirs = []
forbidden_dirs = []
not_found_dirs = []
mov_per = []

puts "Scanning... / 0 / number of wordlist / #{wordlist_size}".yellow
puts
# iterasi daftar dir
dirs.each_with_index do |dir, index|
  dir.chomp!
  
  thread_pool << Thread.new do
    scan_directory(url, dir, index, wordlist_size, valid_dirs, forbidden_dirs, not_found_dirs, mov_per)
  end

  if thread_pool.size >= THREAD_POOL_SIZE
    begin
      thread_pool.each(&:join)
    rescue Interrupt
      puts "Program paused by user. Press Enter to continue or Ctrl+C to exit."
      STDIN.gets
    end
    thread_pool.clear
  end
end

begin
  thread_pool.each(&:join)
rescue Interrupt
  puts "Program paused by user. Press Enter to continue or Ctrl+C to exit."
  STDIN.gets
end

puts "\n\n"
#show choice directory
if valid_dirs.empty?
    puts "Number of directories Found: 0".yellow
  else
    puts "Number of directories Found: #{valid_dirs.size}".yellow
    print "Show the list of directories Found? (y/n) "
    choice = gets.chomp.downcase
    begin
      if choice == 'y'
        puts valid_dirs
      end
    rescue Interrupt
      puts "Program paused by user. Press Enter to continue or Ctrl+C to exit."
      STDIN.gets
      retry
    end
  end
  
  if forbidden_dirs.empty?
    puts "Number of directories Forbidden: 0".blue
  else
    puts "Number of directories Forbidden: #{forbidden_dirs.size}".blue
    print "Show the list of directories Forbidden? (y/n) "
    choice = gets.chomp.downcase
    begin
      if choice == 'y'
        puts forbidden_dirs
      end
    rescue Interrupt
      puts "Program paused by user. Press Enter to continue or Ctrl+C to exit."
      STDIN.gets
      retry
    end
  end

  if not_found_dirs.empty?
    puts "Number of directories Not_found: 0".red
  else
    puts "Number of directories Not_found: #{not_found_dirs.size}".red
    print "Show the list of directories Not_found? (y/n) "
    choice = gets.chomp.downcase
    begin
      if choice == 'y'
        puts not_found_dirs
      end
    rescue Interrupt
      puts "Program paused by user. Press Enter to continue or Ctrl+C to exit."
      STDIN.gets
      retry
    end
  end

if mov_per.empty?
    puts "Number of directories Moved Permanently: 0".red
  else
    puts "Number of directories Moved Permanently: #{mov_per.size}".red
    print "Show the list of directories Moved Permanently? (y/n) "
    choice = gets.chomp.downcase
    begin
      if choice == 'y'
        puts mov_per
      end
    rescue Interrupt
      puts "Program paused by user. Press Enter to continue or Ctrl+C to exit."
      STDIN.gets
      retry
    end
  end