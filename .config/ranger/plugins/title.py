"""Change the terminal window title to ' $PWD' """

import sys
from pathlib import Path, PosixPath
import ranger.api

old_hook_init = ranger.api.hook_init

def hook_init(file_manager):
    """To be called whenever an interaction occurs"""
    def change_title():
        if file_manager.thisdir:
            full_path = PosixPath(str(file_manager.thisdir.path))
            title = ''
            try:
                title = str(full_path.relative_to(Path.home()))
                if title == '.':
                    title = '~'
                else:
                    title = '~/' + title
            except ValueError:
                # File is not in under home directory
                title = str(full_path)
            sys.stdout.write("\33]0;"+ ' ' + title+"\a")
            sys.stdout.flush()

    file_manager.signal_bind('move', change_title)
    file_manager.signal_bind('execute.after', change_title)
    file_manager.signal_bind('tab.change', change_title)
    return old_hook_init(file_manager)

ranger.api.hook_init = hook_init
