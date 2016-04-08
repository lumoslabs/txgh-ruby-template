$:.push(File.expand_path('../lib', __FILE__))

require 'configurator'

ENV['TXGH_CONFIG'] ||= "file://config.yml"

task :configure do
  Configurator.add_project('./config.yml')
end

task :run do
  exec('rackup')
end

task :start do
  pidfile = './txgh.pid'
  exec("rackup -D -P #{pidfile}")
end

task :stop do
  pidfile = './txgh.pid'

  unless File.exist?(pidfile)
    puts 'Server is not running'
    exit 0
  end

  pid = File.read(pidfile).strip.to_i
  Process.kill('TERM', pid)
end

task :status do
  pidfile = './txgh.pid'

  unless File.exist?(pidfile)
    puts "Server is not running"
    exit 0
  end

  pid = File.read(pidfile)
  processes = `ps ax | grep #{pid} | grep -v grep`.strip

  if processes.empty?
    puts 'Server is not running'
  else
    puts 'Server is running'
  end
end
