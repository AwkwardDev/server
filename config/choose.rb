require "fileutils"

$suffix = ARGV[0]

$help = "USAGE: ruby choose.rb <suffix>
  Copies all *.<suffix>.conf files to *.conf.
  Current *.conf files will be overwritten!"

if ($suffix == nil || $suffix == "--help")
  puts $help
end

def rmext(fname)
  fname.chomp(File.extname(fname))
end

Dir.glob("*.#{$suffix}.conf").each do |file|
  FileUtils.cp(file, "#{rmext(rmext(file))}.conf")
end
