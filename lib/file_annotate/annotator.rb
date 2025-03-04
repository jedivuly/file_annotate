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
      lines.any? { |line| line.strip == annotation_text(file) }
    end

    def self.insert_annotation!(lines, file)
      comment = "#{annotation_text(file)}\n"
      if lines.first&.strip == "# frozen_string_literal: true"
        lines.insert(1, comment)
      else
        lines.unshift(comment)
      end
    end

    def self.remove_annotation!(lines, file)
      comment = annotation_text(file)
      if lines[0]&.strip == comment
        lines.delete_at(0)
        true
      elsif lines[1]&.strip == comment
        lines.delete_at(1)
        true
      else
        false
      end
    end
  end
end
