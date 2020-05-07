#! /usr/bin/env ruby

ENV_ERROR = 'Personal Access Token, User, and Org variables must be defined. Please refer to README.md'

begin
  require_relative 'env.rb'
  unless defined?(PAT) && defined?(USER) && defined?(ORG)
    raise StandardError, ENV_ERROR
  end
rescue LoadError
  raise StandardError, ENV_ERROR
end

puts 
puts "Hello! Thank you for using learn_co_cleaner!"
puts
puts "Are you sure you want to close all of the PRs"
puts "you have open against learn-co-students"
puts "and archive all of your forked lessons?"

response = gets.chomp.strip

unless response == "y"
  puts 
  puts "No worries! Come back when you're ready <3"
  exit
end

require 'octokit'
client = Octokit::Client.new(access_token: PAT)

PR_QUERY = "is:open is:pr author:#{USER} org:learn-co-students archived:false"

prs = client.search_issues(PR_QUERY)

pr_counter = 0

until prs.items.length.zero?

  pr_counter += prs.items.length

  prs.items.each do |pr|
    puts 'closing: ' + pr.repository_url[29..-1]
    client.close_issue(pr.repository_url[29..-1], pr.number)
  end

  prs = client.search_issues(PR_QUERY)

end

puts
puts
puts "#{pr_counter} learn-co PRs closed for this user! 😍"
puts

done = false
repos = [{
  easter_egg: "thank you for looking at the code! You can see how far I've bent over backwards to avoid creating the structure of a runtime. If the needs of cleaning up after lessons increases in complexity at all, I'll probably create a full CLI."
}]

until done
  page = 1
  repo_counter = 0

  puts "Please enter a search string. Repositories whose name includes the search string will be transferred to #{ORG}." 
  puts "Good examples are 'bootcamp-prep', your offical cohort name -- check https://github.com/YourUserNameHere?tab=repositories for patterns."
  search_string = gets.chomp.strip

  puts 
  puts "You entered #{search_string} -- is this correct? You're sure you want to transfer these repos to #{ORG}? y/n"

  response = gets.chomp.strip
  unless response.downcase == 'y'
    repos = [] # skips the logic and gives the user another chance to search
  end

  until repos.length.zero?

    repos = client.repositories("#{USER}", sort: 'created', direction: 'asc', page: "#{page}", type: 'fork')

    repos.select! do |repo|
      repo.name.include? search_string
    end

    if repos.length.zero?
      page += 1
    else
      repo_counter += repos.length
      repos.each do |repo|
        puts 'transferring: ' + repo.name + ' to: ' + ORG
        begin
          client.transfer_repository(repo.full_name, ORG, accept: 'application/json')
        rescue Octokit::UnprocessableEntity
          puts
          puts "ERROR: #{repo.name} NOT TRANSFERRED. This likely means it was already transferred."
          puts "This error means nothing happened so it's nothing to be worried about."
          puts "There may be a weird race condition or pagination bug that duplicates calls to repos 😅"
          puts "Github doesn't implement a 'search for forked repos by user', so I do a hacky/buggy thing that I hate to make it work."
          puts "If this persists without also succeeding sometimes, hit control+c to interrupt and run this tool again."
          puts 
        end
      end
    end

  end

  puts 
  puts  "#{repo_counter} repos containing the string #{search_string} were transferred to #{ORG} 👍"
  puts 
  puts 'Would you like to search for more repositories to transfer? y/n'
  puts
  response = gets.chomp.strip

  unless response.downcase == 'y'
    done = true
  end

end
puts 
puts 'Do you want to delete your env.rb file? 🗑 y/n'

response = gets.chomp.strip

puts

if response.downcase == 'y'
  puts 'Deleting the env file (including your Personal Access Token)'
  File.delete('env.rb')
else
  puts 'ok, be sure to delete your Personal Access Token when you are done!'
end

puts 
puts 'Thanks for using learn_co_cleaner! 👋 consider spreading the word to classmates!'