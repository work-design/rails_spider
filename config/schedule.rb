# coding: utf-8
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_
# end

# Learn more: http://github.com/javan/whenever
set :output, "#{Dir.pwd}/rake.log"
#env :PATH, ENV['PATH']

#job_type :rake, "rake everyday:update_and_sync"
#set :environment_variable, :SPIDER_ENV
#set :environment, :development

every :day, :at => '9:30pm' do
  command "cd #{Dir.pwd} && rake everyday:grab_update"
end

every :day, :at => '8:30am' do
  command "cd #{Dir.pwd} && rake everyday:event_image"
end
