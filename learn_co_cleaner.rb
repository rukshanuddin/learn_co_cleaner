#! /usr/bin/env ruby

require_relative 'env.rb'
require 'octokit'

unless defined? PAT && defined? USER
  raise StandardError, 'Personal Access Token and User variables must be defined. Please refer to README.md'
end

client = Octokit::Client.new(access_token: PAT)

prs = client.search_issues("is:open is:pr author:#{USER} org:learn-co-students archived:false")

until prs.items[0].nil?

  prs.items.each do |pr|
      puts 'closing: ' + pr.repository_url[29..-1]
      client.close_issue(pr.repository_url[29..-1], pr.number)
  end

  prs = client.search_issues("is:open is:pr author:#{USER} org:learn-co-students archived:false")

end

puts
puts
puts 'All learn-co PRs closed for this user!'
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