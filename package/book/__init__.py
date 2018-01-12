from IPython.core.display import display, HTML


def display_preamble(disable_scroll=True):
    template = ""
    if disable_scroll:
        template += """
        <script>
        IPython.OutputArea.prototype._should_scroll = function(lines) {
        return false;
        }
        </script>
        """
    display(HTML(template))
