# frozen_string_literal: true

require_relative "file_annotate/version"
require_relative "file_annotate/cli"
require_relative "file_annotate/annotator"
require "rubocop"
require_relative "rubocop/cop/file_annotate/first_line_comment"

module FileAnnotate
  class Error < StandardError; end
  # Your code goes here...
end
