#!/usr/local/bin/ruby

require 'byebug'

class DynDnsWriter
  ZONE            = 'robacarp.com'
  BASE_DIR        = '.'
  TEMPLATE_FILE   = "#{BASE_DIR}/robacarp.com.zonefile.template"
  OUTPUT_FILE     = "./rendered_template"
  DYNAMIC_ADDRESS = "#{BASE_DIR}/dynamic_address"
  LAST_ADDRESS    = "#{BASE_DIR}/last_address"

  attr_reader :ip_address
  attr_reader :last_ip_address

  def self.run
    return unless ddw = DynDnsWriter.new
    ddw.run
  end

  def run
    # return unless need_write? && !
    puts "Good morning! DynDnsWriter reporting in for #{ZONE}."
    puts "Home is reported at #{ip_address}"
    unless ip_address
      puts "> Invalid ip address, aborting"
      return
    end

    puts "Last time, home was at #{last_ip_address}."
    puts "Seems like it needs updating."
    return unless write_zone
    return unless safe_to_reload
    reload_server

    puts "\n\nThis is ddw, signing off. 73"
  end

  def initialize
    unless File.exist? DYNAMIC_ADDRESS
      puts "No dynamic address file found, expected to find it at #{DYNAMIC_ADDRESS}"
      return false
    end
    @ip_address = File.read(DYNAMIC_ADDRESS).strip
    @last_ip_address = nil
  end

  def need_write?
    unless File.exist? LAST_ADDRESS
      puts "no last address found, forcing update"
      return true
    end
    @last_ip_address = File.read(LAST_ADDRESS).strip
    if @last_ip_address == @ip_address
      puts "last address matches, current. not updating"
      false
    else
      true
    end
  end

  def write_zone
    unless File.exist? TEMPLATE_FILE
      puts "> no template found"
      return false
    end
    require 'erb'

    template = File.read(TEMPLATE_FILE)
    rendering = ERB.new(template).result( binding )
    debugger
    puts "writing to #{OUTPUT_FILE}"

    File.open(OUTPUT_FILE, 'w') do |f|
      f.puts rendering
    end

    File.open(LAST_ADDRESS, 'w') do |f|
      f.puts @ip_address
    end

    true
  end

  def safe_to_reload
    `/usr/local/sbin/nsd-checkzone #{ZONE} #{OUTPUT_FILE}`
    success = $? == 0
    puts "> checkzone failed" unless success
    success
  end

  def reload_server
    puts "reloading nsd"
    puts `service nsd reload`
    if $? == 0
      puts 'success'
    else
      puts 'failure'
    end
  end
end


DynDnsWriter.run
