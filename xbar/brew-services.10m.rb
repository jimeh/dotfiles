#!/usr/bin/env ruby
# frozen_string_literal: true

# <xbar.title>Brew Services</xbar.title>
# <xbar.version>v2.1.0</xbar.version>
# <xbar.author>Jim Myhrberg</xbar.author>
# <xbar.author.github>jimeh</xbar.author.github>
# <xbar.desc>List and manage Homebrew Services</xbar.desc>
# <xbar.image>https://i.imgur.com/RDfpTLl.png</xbar.image>
# <xbar.dependencies>ruby</xbar.dependencies>
# <xbar.abouturl>https://github.com/jimeh/dotfiles/tree/main/xbar</xbar.abouturl>
#
# <xbar.var>boolean(VAR_GROUPS=true): List services in started/stopped groups?</xbar.var>
# <xbar.var>string(VAR_BREW_PATH="/usr/local/bin/brew"): Path to "brew" executable.</xbar.var>

# rubocop:disable Style/IfUnlessModifier

require 'open3'
require 'json'

module Xbar
  class Printer
    attr_reader :nested_level

    SUB_STR = '--'
    SEP_STR = '---'
    PARAM_SEP = '|'

    def initialize(nested_level = 0)
      @nested_level = nested_level
    end

    def item(label = nil, **props)
      print_item(label, **props) if !label.nil? && !label.empty?

      yield(sub_printer) if block_given?
    end

    def separator
      print_item(SEP_STR)
    end
    alias sep separator

    private

    def print_item(text, **props)
      output = [text]
      unless props.empty?
        output << PARAM_SEP
        output += props.map { |k, v| "#{k}=\"#{v}\"" }
      end

      $stdout.print(SUB_STR * nested_level, output.join(' '))
      $stdout.puts
    end

    def sub_printer
      @sub_printer || self.class.new(nested_level + 1)
    end
  end
end

module Brew
  class CommandError < StandardError; end

  class Common
    def self.prefix(value = nil)
      return @prefix if value.nil? || value == ''

      @prefix = value
    end

    private

    def prefix
      self.class.prefix
    end

    def default_printer
      @default_printer ||= ::Xbar::Printer.new
    end

    def cmd(*args)
      out, err, s = Open3.capture3(*args)
      raise CommandError, "#{args.join(' ')}: #{err}" if s.exitstatus != 0

      out
    end

    def brew_path
      @brew_path ||= ENV.fetch('VAR_BREW_PATH', '/usr/local/bin/brew')
    end

    def brew_check(printer = nil)
      printer ||= default_printer
      return if File.exist?(brew_path)

      printer.item("#{prefix}↑:warning:", dropdown: false)
      printer.sep
      printer.item('Homebrew not found', color: 'red')
      printer.item("Executable \"#{brew_path}\" does not exist.")
      printer.sep
      printer.item(
        'Visit https://brew.sh/ for installation instructions',
        href: 'https://brew.sh'
      )

      exit 0
    end
  end

  class Service
    attr_reader :name, :status, :user

    def self.from_line(line)
      parts = line.split
      name = parts[0]
      if %w[started stopped error unknown].include?(parts[1])
        status = parts[1]
        user = parts[2]
      else
        # Some services (dbus and logrotate for example) don't show a status
        # when running "brew services list" at the moment. Instead they only
        # show the service name and the user. So we work around this issue.
        status = 'unknown'
        user = parts[1]
      end

      new(name: name, status: status, user: user)
    end

    def initialize(name:, status:, user: nil)
      @name = name
      @status = status
      @user = user
    end

    def started?
      @started ||= @status.downcase == 'started'
    end

    def stopped?
      @stopped ||= @status.downcase == 'stopped'
    end

    def error?
      @error ||= @status.downcase == 'error'
    end

    def unknown_status?
      @unknown_status ||= @status.downcase == 'unknown'
    end
  end

  class Services < Common
    prefix ':bulb:'

    def run
      printer = default_printer

      brew_check(printer)

      printer.item(
        "#{prefix}" \
        "#{started_services.size}/#{services.size - started_services.size}",
        dropdown: false
      )
      printer.sep
      printer.item('Brew Services')

      printer.item(status_label) do |printer|
        printer.sep
        printer.item(':hourglass: Refresh', refresh: true)
        printer.sep
        if stopped_services.size.positive?
          printer.item(
            "Start All (#{stopped_services.size} services)",
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'start', param3: '--all'
          )
        else
          printer.item("Start All (#{stopped_services.size} services)")
        end
        if started_services.size.positive?
          printer.item(
            "Stop All (#{started_services.size} services)",
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'stop', param3: '--all'
          )
        else
          printer.item("Stop All (#{started_services.size} services)")
        end
        if services.size.positive?
          printer.item(
            'Restart All ' \
            "(#{started_services.size + stopped_services.size} services)",
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'restart', param3: '--all'
          )
        else
          printer.item("Restart All (#{services.size} services)")
        end
      end
      use_groups? ? print_service_groups(printer) : print_services(printer)
    end

    private

    def status_label
      label = []
      if started_services.size.positive?
        label << "#{started_services.size} started"
      end
      if stopped_services.size.positive?
        label << "#{stopped_services.size} stopped"
      end
      if errored_services.size.positive?
        label << "#{errored_services.size} error"
      end
      if unknown_status_services.size.positive?
        label << "#{unknown_status_services.size} unknown"
      end

      label = ['no services available'] if label.empty?
      label.join(' / ')
    end

    def use_groups?
      ENV.fetch('VAR_GROUPS', 'true') == 'true'
    end

    def print_service_groups(printer)
      if started_services.size.positive?
        printer.sep
        printer.item("Started (#{started_services.size}):")
        started_services.each do |service|
          print_service(printer, service)
        end
      end
      if stopped_services.size.positive?
        printer.sep
        printer.item("Stopped (#{stopped_services.size}):")
        stopped_services.each do |service|
          print_service(printer, service)
        end
      end
      if errored_services.size.positive?
        printer.sep
        printer.item("Error (#{errored_services.size}):")
        errored_services.each do |service|
          print_service(printer, service)
        end
      end
      if unknown_status_services.size.positive?
        printer.sep
        printer.item("Unknown Status (#{unknown_status_services.size}):")
        unknown_status_services.each do |service|
          print_service(printer, service)
        end
      end
    end

    def print_services(printer)
      printer.sep
      services.each do |service|
        print_service(printer, service)
      end
    end

    def print_service(printer, service)
      icon = if service.started?
               ':white_check_mark:'
             elsif service.stopped?
               ':ballot_box_with_check:'
             elsif service.error?
               ':warning:'
             elsif service.unknown_status?
               ':question:'
             end

      printer.item("#{icon} #{service.name}") do |printer|
        if service.started? || service.error? || service.unknown_status?
          printer.item(
            'Stop',
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'stop', param3: service.name
          )
          printer.item(
            'Restart',
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'restart', param3: service.name
          )
        end
        if service.stopped? || service.unknown_status?
          printer.item(
            'Start',
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'start', param3: service.name
          )
        end

        printer.sep
        printer.item("State: #{service.status}")
        printer.item("User: #{service.user || '<none>'}")

        if service.stopped?
          printer.sep
          printer.item('Uninstall') do |printer|
            printer.item('Are you sure?')
            printer.sep
            printer.item(
              'Yes',
              terminal: true, refresh: true,
              shell: brew_path, param1: 'uninstall',
              param2: service.name
            )
          end
        end
      end
    end

    def started_services
      @started_services ||= services.select(&:started?)
    end

    def stopped_services
      @stopped_services ||= services.select(&:stopped?)
    end

    def errored_services
      @errored_services ||= services.select(&:error?)
    end

    def unknown_status_services
      @unknown_status_services ||= services.select(&:unknown_status?)
    end

    def services
      return @services if @services

      found = false
      @services = cmd(
        brew_path, 'services', 'list'
      ).each_line.each_with_object([]) do |line, memo|
        # Ignore header line and everything before it.
        unless found
          found = line.strip.match(/^Name\s+Status\s+User\s+(File|Plist)$/)
          next
        end

        memo.push(Service.from_line(line))
      end
    end
  end
end

begin
  Brew::Services.new.run
rescue StandardError => e
  puts "ERROR: #{e.message}:\n\t#{e.backtrace.join("\n\t")}"
  exit 1
end

# rubocop:enable Style/IfUnlessModifier
