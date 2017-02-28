# debug, warn, fail, fatal
def logger(tag, string, tag_color = :uncolorize, level = "debug")
  if USE_COLOR
    color = nil
    case level
    when "debug"
      color = :uncolorize
    when "warn"
      color = :yellow
    when "fail"
      color = :red
    when "fatal"
      color = :on_red
    else
      color = :swap
    end
    puts "[#{level.upcase}]".send(color)+"<#{Time.now.strftime('%T %x')}>"+"[#{tag}]".send(tag_color)+" #{string}"
  else
    puts "[#{level.upcase}]<#{Time.now.strftime('%T %x')}>[#{tag}] #{string}"
  end
end

require_relative "hub"
require_relative "server"
require_relative "lobby"
require_relative "player"
require_relative "chatterbox"
require_relative "chatterbox/authentication"
