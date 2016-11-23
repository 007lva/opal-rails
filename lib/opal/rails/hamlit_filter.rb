module Hamlit
  class Filters
    class Opal < Base
      def compile(node)
        case @format
        when :xhtml
          compile_xhtml(node)
        else
          compile_html(node)
        end

        private

        def compile_html(node)
          temple = [:multi]
          temple << [:static, "<script>\n".freeze]
          temple << [:static, ::Opal.compile(text)]
          temple << [:static, "\n</script>".freeze]
          temple
        end

        def compile_xhtml(node)
          temple = [:multi]
          temple << [:static, "<script type='text/javascript'>\n  //<![CDATA[\n".freeze]
          temple << [:static, ::Opal.compile(text)]
          temple << [:static, "\n  //]]>\n</script>".freeze]
          temple
        end
      end
    end
  end
end
