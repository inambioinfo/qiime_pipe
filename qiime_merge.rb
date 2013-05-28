#!/usr/bin/env ruby

require 'pp'
require 'optparse'
require_relative 'lib/qiime'

ARGV << "-h" if ARGV.empty?

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]"

  opts.on("-h", "--help", "Display this screen" ) do
    $stderr.puts opts
    exit
  end

  opts.on("-m", "--mapping_files <files>", String, "Mapping file to process") do |o|
    options[:mapping_files] = o
  end

  opts.on("-m", "--fasta_files <files>", String, "Post split_library FASTA files") do |o|
    options[:mapping_files] = o
  end

  opts.on("-o", "--dir_out <dir>", String, "Output directory") do |o|
    options[:dir_out] = o
  end

  opts.on("-f", "--force", "Force overwrite log file and output directory") do |o|
    options[:force] = o
  end

  opts.on("-c", "--chimera", "Chimera filter data") do |o|
    options[:chimera] = o
  end

  options[:chimera_db] = Qiime::DEFAULT_CHIMERA_DB
  opts.on("-D", "--chimera_db <file>", String, "Chimera database (#{Qiime::DEFAULT_CHIMERA_DB})") do |o|
    options[:chimera_db] = o || Qiime::DEFAULT_CHIMERA_DB
  end

  options[:cpus] = Qiime::DEFAULT_CPUS
  opts.on("-C", "--cpus <int>", Integer, "Number of CPUs to use (#{Qiime::DEFAULT_CPUS})") do |o|
    options[:cpus] = o
  end

  opts.on("-e", "--email <string>", String, "Send email alert") do |o| 
    options[:email] = o
  end
end.parse!

raise OptionParser::MissingArgument, "--file_sff" if options[:file_sff].nil?
raise OptionParser::MissingArgument, "--file_map" if options[:file_map].nil?
raise OptionParser::MissingArgument, "--dir_out"  if options[:dir_out].nil?
raise OptionParser::InvalidOption,   "no such file: #{options[:file_sff]}" unless File.file?(options[:file_sff])
raise OptionParser::InvalidOption,   "no such file: #{options[:file_map]}" unless File.file?(options[:file_map])

m = Qiime::MapFile.new
m.parse_mapping_file(ARGV[0])
m.merge_mapping_file(ARGV[1])

puts m
