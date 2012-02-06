# encoding: utf-8

$HOME = File.expand_path(ENV['HOME'] || '~')
$DOTFILES = File.expand_path('..', __FILE__)
$DOTPFILES = "#{$DOTFILES}/private"

desc "Create all symlinks in home folder (#{$HOME})"
task :symlink => 'symlink:all'
task :link    => 'symlink:all'

namespace :symlink do

  # Paths to symlink from dotfiles
  paths = [
    'bundle', 'emacs.d', 'erlang', 'gemrc', 'gitconfig', 'gitignore',
    'hgrc', 'irbrc', 'powconfig', 'rspec', 'tmux.conf'
  ]

  # Target directory to put symlinks in (defaults to home folder).
  target = File.expand_path(ENV["TARGET"] ? ENV["TARGET"] : $HOME)

  task :dotfiles do
    link_paths($DOTFILES, "#{target}/.dotfiles")
  end

  desc "Execute \"rake symlink\" in #{$DOTPFILES}"
  task :private do
    system "rake --rakefile=\"#{$DOTPFILES}/Rakefile\" symlink"
  end

  task :all => ["symlink:private", "symlink:paths", "symlink:shell_loaders"]

  task :paths => :dotfiles do
    paths.each do |path|
      link_paths(".dotfiles/#{path}", "#{target}/.#{path}")
    end
  end

  task :shell_loaders => :dotfiles do
    link_paths(".dotfiles/load_shellrc.sh", "#{target}/.profile")
    link_paths(".dotfiles/load_shellrc.sh", "#{target}/.zprofile")
  end
end

namespace :install do
  desc "Install Homebrew"
  task :homebrew do
    system '/usr/bin/ruby -e ' +
      '"$(curl -fsSL https://raw.github.com/gist/323731)"'
  end

  desc "Install rbenv to #{$HOME}/.rbenv"
  task :rbenv do
    target = File.join($HOME, '.rbenv')
    git_clone('git://github.com/sstephenson/rbenv.git', target)
  end

  desc "Install nvm to #{$HOME}/.nvm"
  task :nvm do
    target = File.join($HOME, '.nvm')
    git_clone('https://github.com/creationix/nvm.git', target)
  end

  desc "Install virtualenv-burrito"
  task :virtualenv do
    system 'curl -s https://raw.github.com/brainsik/virtualenv-burrito/' +
      'master/virtualenv-burrito.sh | bash'
  end
end


def link_paths(src, to)
  if !File.exists?(to)
    puts "  symlink: #{to} --> #{src}"
    File.symlink(src, to)
  else
    puts "   exists: #{to}"
  end
end

def git_clone(repo, target)
  if File.exist?(target)
    puts "#{target} already exists."
  else
    system "git clone \"#{repo}\" \"#{target}\""
  end
end
