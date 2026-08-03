# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require_relative '../brew-updates.1h'

class BrewUpdatesTest < Minitest::Test
  class FakeFormulaUpdates < Brew::FormulaUpdates
    attr_reader :commands

    def initialize(casks:, info_casks: [], info_error: nil)
      @outdated_data = { 'formulae' => [], 'casks' => casks }
      @info_casks = info_casks
      @info_error = info_error
      @commands = []
    end

    private

    def outdated
      @outdated_data
    end

    def brew_path
      '/opt/homebrew/bin/brew'
    end

    def cmd(*args)
      commands << args
      raise @info_error if @info_error

      JSON.generate('casks' => @info_casks)
    end
  end

  def test_uses_live_app_version_for_outdated_cask
    service = FakeFormulaUpdates.new(
      casks: [outdated_cask('firefox', '123.0', '153.0.1')],
      info_casks: [info_cask('firefox', '151.0.1', '15126.5.20')]
    )

    cask = service.send(:casks).fetch(0)

    assert_equal '151.0.1', cask.current_version
    assert_equal ['151.0.1'], cask.installed_versions
    assert_equal [
      '/opt/homebrew/bin/brew', 'info', '--cask', '--json=v2', 'firefox'
    ], service.commands.fetch(0)
  end

  def test_includes_bundle_build_when_latest_version_has_build_component
    service = FakeFormulaUpdates.new(
      casks: [outdated_cask('affinity-photo', '2.3.1', '2.6.5,3782')],
      info_casks: [info_cask('affinity-photo', '2.6.4', '3634')]
    )

    cask = service.send(:casks).fetch(0)

    assert_equal '2.6.4,3634', cask.current_version
    assert_equal ['2.6.4,3634'], cask.installed_versions
  end

  def test_falls_back_to_receipt_when_bundle_metadata_is_missing
    service = FakeFormulaUpdates.new(
      casks: [outdated_cask('font-fontawesome', '7.2.0', '7.3.1')],
      info_casks: [info_cask('font-fontawesome', nil, nil)]
    )

    cask = service.send(:casks).fetch(0)

    assert_equal '7.2.0', cask.current_version
    assert_equal ['7.2.0'], cask.installed_versions
  end

  def test_falls_back_to_receipt_when_brew_info_fails
    service = FakeFormulaUpdates.new(
      casks: [outdated_cask('firefox', '123.0', '153.0.1')],
      info_error: Xbar::CommandError.new('brew info failed')
    )

    cask = service.send(:casks).fetch(0)

    assert_equal '123.0', cask.current_version
    assert_equal ['123.0'], cask.installed_versions
  end

  def test_does_not_request_cask_info_without_outdated_casks
    service = FakeFormulaUpdates.new(casks: [])

    assert_empty service.send(:casks)
    assert_empty service.commands
  end

  private

  def outdated_cask(name, installed_version, current_version)
    {
      'name' => name,
      'installed_versions' => [installed_version],
      'current_version' => current_version,
      'pinned' => false,
      'pinned_version' => nil
    }
  end

  def info_cask(token, bundle_short_version, bundle_version)
    {
      'token' => token,
      'bundle_short_version' => bundle_short_version,
      'bundle_version' => bundle_version
    }
  end
end
