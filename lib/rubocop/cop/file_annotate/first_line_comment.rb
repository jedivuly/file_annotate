# frozen_string_literal: true

module RuboCop
  module Cop
    module FileAnnotate
      # 檢查檔案的第一行是否符合預期格式的 RuboCop Cop
      class FirstLineComment < Cop
        MSG = "Missing file path comment on the first line."

        def investigate(processed_source)
          file_path    = processed_source.file_path
          actual_first = processed_source.lines[0]&.strip
          expected     = "# #{file_path}"

          return if actual_first == expected

          add_offense(nil, location: source_range(processed_source.buffer, 0, 0), message: MSG)
        end

        # autocorrect 實作
        def autocorrect(_node)
          file_path = processed_source.file_path
          expected  = "# #{file_path}\n"
          lambda do |corrector|
            corrector.insert_before(processed_source.buffer.source_range, expected)
          end
        end
      end
    end
  end
end
