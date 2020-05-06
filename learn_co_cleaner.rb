#! /usr/bin/env ruby

ENV_ERROR = 'Personal Access Token and User variables must be defined. Please refer to README.md'

begin
  require_relative 'env.rb'
  unless defined?(PAT) && defined?(USER) 
    raise StandardError, ENV_ERROR
  end
rescue LoadError
  raise StandardError, ENV_ERROR
end

require 'octokit'
client = Octokit::Client.new(access_token: PAT)

QUERY = "is:open is:pr author:#{USER} org:learn-co-students archived:false"

prs = client.search_issues(QUERY)

counter = 0

until prs.items[0].nil?

  counter += prs.items.length

  prs.items.each do |pr|
      puts 'closing: ' + pr.repository_url[29..-1]
      client.close_issue(pr.repository_url[29..-1], pr.number)
  end

  prs = client.search_issues(QUERY)

end

puts
puts
puts "#{counter} learn-co PRs closed for this user!"
puts
puts 'do you want to delete your ENV file? y/n'

response = gets.chomp.strip

puts

if response.downcase == 'y'
  puts 'deleting the env file (including your Personal Access Token)'
  File.delete('env.rb')
else
  puts 'ok, be sure to delete your Personal Access Token when you are done!'
end

puts 
puts 'thanks for using learn_co_cleaner!'