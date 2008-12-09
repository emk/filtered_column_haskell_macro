class HaskellMacro < FilteredColumn::Macros::Base
  # Apply Haskell syntax highlighting using HsColour.
  def self.filter(attributes, inner_text='', text='')
    lang       = attributes['lang'] || 'haskell'
    title      = attributes['title']
    cssclass   = attributes['class'] || ''
    linenumber = attributes['linenumber']

    inner_text = inner_text.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

    html =
      IO.popen("HsColour -css", "r+") do |f|
        pid = fork { f.write inner_text; f.close; Kernel.exit!(0) }
        f.close_write
        result = f.read
        Process.waitpid pid
        result
      end
    
    html.gsub!(/.*<pre>/m,"<pre><code class=\"#{h lang}_code #{h cssclass}\">")
    html.gsub!(/<\/pre>.*/m,"</code></pre>")

    if linenumber
      lines = html.split(/\n/).size
      linenumbers_html = (1..lines).to_a.collect{|line| line.to_s}.join("\n")

      html = "<table><tr><td class=\"line_numbers\">\n<pre>\n#{linenumbers_html}\n</pre>\n</td><td class=\"code\" width=\"100%\">#{html}</td></tr></table>"
    end

    if title
      title_html = "<div class=\"code_title\">#{h title}</div>"
    else
      title_html = ''
    end

    "<div class=\"code_block\">#{title_html}#{html}</div>"
  end

  protected

  def self.h str
    CGI.escape(str)
  end
end
