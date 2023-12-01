#!/usr/bin/env ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'fileutils'
require 'pastel'

pastel = Pastel.new

def get_input(year, day)
  path = "data/#{year}/#{day}.txt"
  FileUtils.mkdir_p "data/#{year}"
  return File.read(path) if File.exist? path

  cookie = File.read('.cookie').strip

  uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
  request = Net::HTTP::Get.new(uri)
  request['Cookie'] = "session=#{cookie}"
  request['User-Agent'] = 'https://github.com/d-nery/aoc <danielnso97@gmail.com>'
  input = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(request)
  end.body.strip
  File.write(path, input)
  input
end

problem = ARGV[0]
day = ARGV[1] || Time.now.day
year = ARGV[2] || Time.now.year

require "./#{year}/day#{day}"

puts '== AoC Problem Runner =='
puts "Day #{pastel.yellow(day)}"
puts "Year #{pastel.yellow(year)}"
puts "Problem #{pastel.yellow(problem || 'test')}"
puts '------------------------'
puts

puts pastel.dim('Getting input...')
input = get_input(year, day)
puts pastel.dim('Done!')
puts '------------------------'
puts

puts 'Running...'

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
result = if problem == '1'
           part_one input
         elsif problem == '2'
           part_two input
         else
           test
           exit
         end
finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts "Done in #{((finish - start) * 1000).round(1)}ms! Result #{pastel.green(result)}"
