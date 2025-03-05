# frozen_string_literal: true

require 'pathname'

module RuboCop
  module Cop
    module FileAnnotate
      # 檢查檔案開頭的相對路徑註解是否符合設定
      class FirstLineComment < Base
        extend AutoCorrector

        MSG_MISSING = "Missing file path comment."
        MSG_FORBIDDEN = "File path comment is forbidden on the first line."

        def on_new_investigation
          return if processed_source.lines.empty?

          @project_root = Pathname.pwd
          @absolute_path = Pathname.new(processed_source.file_path)
          @relative_path = @absolute_path.relative_path_from(@project_root).to_s
          @expected_comment = "# #{@relative_path}"

          case enforced_style
          when :required
            check_required
          when :forbidden
            check_forbidden
          end
        end

        private

        def enforced_style
          cop_config.fetch('EnforcedStyle', 'required').to_sym
        end

        def check_required
          return if annotated_correctly?

          position = 0 # 檔案開頭位置
          range = Parser::Source::Range.new(processed_source.buffer, position, position)

          add_offense(range, message: MSG_MISSING) do |corrector|
            corrector.insert_before(range, "#{@expected_comment}\n")
          end
        end

        def check_forbidden
          first_line = processed_source.lines[0]&.strip
          return unless first_line == @expected_comment

          range = processed_source.buffer.line_range(1)
          add_offense(range, message: MSG_FORBIDDEN) do |corrector|
            corrector.remove(range_with_trailing_newline(range))
          end
        end

        def annotated_correctly?
          first_line = processed_source.lines[0]&.strip
          first_line == @expected_comment
        end

        def range_with_trailing_newline(range)
          buffer = processed_source.buffer
          source = buffer.source
          end_pos = range.end_pos
          end_pos += 1 if source[end_pos] == "\n"
          Parser::Source::Range.new(buffer, range.begin_pos, end_pos)
        end
      end
    end
  end
end
