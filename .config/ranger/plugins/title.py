import ranger.api
import sys
from pathlib import Path, PosixPath

old_hook_init = ranger.api.hook_init

def hook_init(fm):
    def on_cd():
        if fm.thisdir:
            full_path = PosixPath(str(fm.thisdir.path))
            title = ''
            try:
                title = str(full_path.relative_to(Path.home()))
                if title == '.':
                    title = '~'
                else:
                    title = '~/' + title
            except ValueError:
                # This means the file is not in under home directory
                title = str(full_path)
            sys.stdout.write("\33]0;"+ ' ' + title+"\a")
            sys.stdout.flush()

    fm.signal_bind('move', on_cd)
    fm.signal_bind('execute.after', on_cd)
    fm.signal_bind('tab.change', on_cd)
    return old_hook_init(fm)

ranger.api.hook_init = hook_init
