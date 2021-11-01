#!/usr/bin/env ruby
# frozen_string_literal: true

# <xbar.title>Brew Services</xbar.title>
# <xbar.version>v2.0.0</xbar.version>
# <xbar.author>Jim Myhrberg</xbar.author>
# <xbar.author.github>jimeh</xbar.author.github>
# <xbar.desc>List and manage Brew Services</xbar.desc>
# <xbar.image>https://i.imgur.com/cAVfsvF.png</xbar.image>
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
      name, status, user, _plist = line.split
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
      !started?
    end
  end

  class Services < Common
    prefix ':bulb:'

    def run
      printer = default_printer

      brew_check(printer)

      printer.item(
        "#{prefix}#{started_services.size}/#{stopped_services.size}",
        dropdown: false
      )
      printer.sep
      printer.item('Brew Services')
      printer.item(
        "#{started_services.size} started / " \
        "#{stopped_services.size} stopped"
      ) do |printer|
        printer.sep
        printer.item(':hourglass: Refresh', refresh: true)
      end
      printer.sep
      use_groups? ? print_service_groups(printer) : print_services(printer)
    end

    private

    def use_groups?
      ENV.fetch('VAR_GROUPS', 'true') == 'true'
    end

    def print_service_groups(printer)
      printer.item('Started:')
      started_services.each do |service|
        print_service(printer, service)
      end
      printer.sep
      printer.item('Stopped:')
      stopped_services.each do |service|
        print_service(printer, service)
      end
    end

    def print_services(printer)
      services.each do |service|
        print_service(printer, service)
      end
    end

    def print_service(printer, service)
      label = if service.started?
                ":white_check_mark: #{service.name}"
              else
                ":ballot_box_with_check: #{service.name}"
              end

      printer.item(label) do |printer|
        if service.started?
          printer.item(
            'Stop',
            terminal: false, refresh: true, shell: brew_path,
            param1: 'services', param2: 'stop', param3: service.name
          )
        else
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
      @stopped_services ||= services.reject(&:started?)
    end

    def services
      @services ||= cmd(
        brew_path, 'services', 'list'
      ).each_line.each_with_object([]) do |line, memo|
        next if line.match(/^Name\s+Status\s+User\s+Plist$/)

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
