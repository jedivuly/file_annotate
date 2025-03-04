# frozen_string_literal: true

require "thor"
require "file_annotate/annotator"

module FileAnnotate
  # CLI 負責處理指令列操作
  class CLI < Thor
    desc "add", "批次將檔案路徑註解插入所有 .rb 檔案"
    def add
      puts "=== FileAnnotate CLI - Add file path comments ==="
      FileAnnotate::Annotator.annotate_all
      puts "Done!"
    end

    desc "remove", "批次移除所有檔案的檔案路徑註解"
    def remove
      puts "=== FileAnnotate CLI - Remove file path comments ==="
      FileAnnotate::Annotator.remove_all
      puts "Done!"
    end
  end
end
