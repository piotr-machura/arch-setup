# ---------------------
# IPYTHON CONFIGURATION
# ---------------------
import sys

c.InteractiveShellApp.ignore_cwd = True
c.TerminalIPythonApp.display_banner = True
c.InteractiveShell.colors = 'Linux'
c.InteractiveShell.xmode = 'Minimal'
c.TerminalInteractiveShell.banner1 = 'IPython - version ' + sys.version.split(' ')[0] + '\n'
c.TerminalInteractiveShell.colors = 'Neutral'
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.display_completions = 'readlinelike'
c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.editor = 'nvim'
c.TerminalInteractiveShell.extra_open_editor_shortcuts = True
c.TerminalInteractiveShell.prompt_includes_vi_mode = False
c.TerminalInteractiveShell.term_title = True
c.TerminalInteractiveShell.term_title_format = 'IPython ' + sys.version.split(' ')[0]
c.TerminalInteractiveShell.true_color = False
c.InteractiveShellApp.exec_lines = [
    'from matplotlib.pylab import *',
    'from matplotlib import pyplot as plt',
    'import numpy as np',
    'from IPython.display import display',
    'from IPython.core.pylabtools import figsize, getfigs',
]
