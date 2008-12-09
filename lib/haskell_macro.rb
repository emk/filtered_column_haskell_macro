class HaskellMacro < FilteredColumn::Macros::Base
  # Apply Haskell syntax highlighting using HsColour.
  def self.filter(attributes, inner_text='', text='')
    lang       = attributes['lang'] || 'haskell'
    title      = attributes['title']
    cssclass   = attributes['class']
    linenumber = attributes['linenumber']

    text = text.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

    IO.popen("HsColour -css", "r+") do |f|
      pid = fork { f.write inner_text; f.close; Kernel.exit!(0) }
      f.close_write
      text = f.read
      Process.waitpid pid
    end
    
    text.gsub!(/.*<pre>/m,"<pre><code class=\"typocode_#{lang} #{cssclass}\">")
    text.gsub!(/<\/pre>.*/m,"</code></pre>")

    if(linenumber)
      lines = text.split(/\n/).size
      linenumbers = (1..lines).to_a.collect{|line| line.to_s}.join("\n")

      text = "<table class=\"typocode_linenumber\"><tr><td class=\"lineno\">\n<pre>\n#{linenumbers}\n</pre>\n</td><td width=\"100%\">#{text}</td></tr></table>"
    end

    if(title)
      titlecode="<div class=\"codetitle\">#{title}</div>"
    else
      titlecode=''
    end

    "<div class=\"typocode\">#{titlecode}#{text}</div>"
  end
end
