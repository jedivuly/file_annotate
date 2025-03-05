# FileAnnotate 檔案路徑註解套件

FileAnnotate 是一個 Ruby Gem，提供兩大功能：

CLI 批次處理：自動在專案內每個 .rb 檔案的第一行插入該檔案路徑的註解。

RuboCop 插件：提供自訂 Cop，檢查並確保 .rb 檔案第一行為正確的檔案路徑註解，並支援自動修正。

## Installation 安裝方式

在專案的 Gemfile 中加入：
```ruby
gem "file_annotate"
```
然後執行：
```bash
bundle install
```
或是直接安裝：
```bash
gem install file_annotate
```

## Usage 使用說明

✅ CLI 批次處理
執行以下指令，會自動為專案中所有 .rb 檔案加上第一行檔案路徑註解：
```bash
file_annotate add
```

執行以下指令，會自動檢查專案中所有 .rb 檔案的第一行或第二行為檔案路徑註解時，給予刪除：
```bash
file_annotate remove
```

✅ RuboCop 規則檢查
在你的專案 .rubocop.yml 檔案中加入：
```yaml
require:
  - file_annotate/rubocop

FileAnnotate/FirstLineComment:
  Enabled: true
  EnforcedStyle: forbidden # default is 'required', can be 'forbidden'
```

然後執行 RuboCop：
```bash
rubocop
```

若需要自動修正缺少的檔案註解，請使用：
```bash
rubocop -A
```
( 設為forbidden時，則刪除註解 )

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/file_annotate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
