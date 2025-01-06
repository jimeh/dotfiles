require 'irb/completion'
IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:USE_MULTILINE] = false if ENV['INSIDE_EMACS']
IRB.conf[:USE_READLINE] = false if ENV['INSIDE_EMACS']
