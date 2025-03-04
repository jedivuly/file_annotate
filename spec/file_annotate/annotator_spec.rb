# frozen_string_literal: true

require "spec_helper"
require "fileutils"
require "file_annotate/annotator"

RSpec.describe FileAnnotate::Annotator do
  let(:test_dir) { "spec/tmp" }
  let(:test_file_path) { "#{test_dir}/example.rb" }

  before do
    FileUtils.mkdir_p(test_dir)
  end

  after do
    FileUtils.rm_rf(test_dir)
  end

  describe ".annotate_all" do
    context "當檔案沒有 frozen_string_literal 註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          class Example
          end
        RUBY
      end

      it "會在第一行加入檔案路徑註解" do
        described_class.annotate_all
        result = File.read(test_file_path)
        expect(result.lines.first.strip).to eq("# #{test_file_path}")
      end
    end

    context "當檔案有 frozen_string_literal 註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          # frozen_string_literal: true

          class Example
          end
        RUBY
      end

      it "會在 frozen_string_literal 註解下一行加入檔案路徑註解" do
        described_class.annotate_all
        result = File.read(test_file_path)
        expect(result.lines[1].strip).to eq("# #{test_file_path}")
      end
    end

    context "當檔案已經有相同檔案路徑註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          # #{test_file_path}

          class Example
          end
        RUBY
      end

      it "不會重複加入註解" do
        described_class.annotate_all
        result = File.read(test_file_path)
        expect(result.scan(/^# #{Regexp.escape(test_file_path)}$/).size).to eq(1)
      end
    end
  end

  describe ".remove_all" do
    context "當檔案第一行是檔案路徑註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          # #{test_file_path}
          class Example
          end
        RUBY
      end

      it "會刪除第一行的檔案路徑註解" do
        described_class.remove_all
        result = File.read(test_file_path)
        expect(result).not_to include("# #{test_file_path}")
        expect(result.lines.first.strip).to eq("class Example")
      end
    end

    context "當檔案第二行是檔案路徑註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          # frozen_string_literal: true
          # #{test_file_path}

          class Example
          end
        RUBY
      end

      it "會刪除第二行的檔案路徑註解" do
        described_class.remove_all
        result = File.read(test_file_path)
        expect(result).not_to include("# #{test_file_path}")
        expect(result.lines[0].strip).to eq("# frozen_string_literal: true")
        expect(result.lines[1].strip).to eq("")
      end
    end

    context "當檔案第三行或之後有檔案路徑註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          # frozen_string_literal: true

          class Example
          end

          # #{test_file_path}
        RUBY
      end

      it "不會刪除第三行或之後的檔案路徑註解" do
        described_class.remove_all
        result = File.read(test_file_path)
        expect(result).to include("# #{test_file_path}")
      end
    end

    context "當檔案沒有檔案路徑註解" do
      before do
        File.write(test_file_path, <<~RUBY)
          class Example
          end
        RUBY
      end

      it "不會修改檔案" do
        expect { described_class.remove_all }
          .not_to change { File.read(test_file_path) }
      end
    end
  end
end
