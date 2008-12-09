require 'test_helper'

# Adapted from filtered_column_code_macro test suite, greatly truncated.
class HaskellMacroTest < ActiveSupport::TestCase
  test "should retrieve macro" do
    assert_equal HaskellMacro, FilteredColumn.macros[:haskell_macro]
  end

  test "should syntax-highlight Haskell code" do
    html = process_macros "<macro:haskell>type M a = M a</macro:haskell>"
    expected = "<div class=\"typocode\"><pre><code class=\"typocode_haskell \"><span class='keyword'>type</span> <span class='conid'>M</span> <span class='varid'>a</span> <span class='keyglyph'>=</span> <span class='conid'>M</span> <span class='varid'>a</span></code></pre></div>"
    assert_equal expected, html
  end

  test "should remove leading and trailing newlines" do
    html = process_macros "<macro:haskell>\ntype M a = M a\n</macro:haskell>"
    expected = "<div class=\"typocode\"><pre><code class=\"typocode_haskell \"><span class='keyword'>type</span> <span class='conid'>M</span> <span class='varid'>a</span> <span class='keyglyph'>=</span> <span class='conid'>M</span> <span class='varid'>a</span></code></pre></div>"
    assert_equal expected, html
  end

  private

  def process_macros(text)
    FilteredColumn::Processor.new(nil, text).filter
  end
end
