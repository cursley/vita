$LOAD_PATH.unshift(File.expand_path(__dir__))

require "vita/format"
require "vita/garden"
require "vita/garden_note"
require "vita/html"
require "vita/link"
require "vita/note"
require "vita/renderer"
require "vita/rendering_context"
require "vita/version"

module Vita
  BASE_DIRECTORY = File.expand_path("..", __dir__)
  BANNER = <<~'BANNER'
           _ _
    __   _(_) |_ __ _
    \ \ / / | __/ _` |
     \ V /| | || (_| |
      \_/ |_|\__\__,_|

  BANNER
end
