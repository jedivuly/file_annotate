# frozen_string_literal: true

module FileAnnotate
  # 負責對檔案內容進行註解的處理
  class Annotator
    def self.annotate_all
      each_rb_file do |file|
        lines = File.readlines(file)
        next if annotated?(lines, file)

        insert_annotation!(lines, file)
        File.write(file, lines.join)
      end
    end

    def self.remove_all
      each_rb_file do |file|
        lines = File.readlines(file)
        File.write(file, lines.join) if remove_annotation!(lines, file)
      end
    end

    def self.each_rb_file(&block)
      Dir.glob("**/*.rb").each(&block)
    end

    def self.annotation_text(file)
      "# #{file}"
    end

    def self.annotated?(lines, file)
      lines.first&.strip == annotation_text(file)
    end

    def self.insert_annotation!(lines, file)
      lines.unshift("#{annotation_text(file)}\n")
    end

    def self.remove_annotation!(lines, file)
      if annotated?(lines, file)
        lines.delete_at(0)
        true
      else
        false
      end
    end
  end
end
