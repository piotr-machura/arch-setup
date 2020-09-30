from ranger.config.commands import open_with
def execute(self):
    app, flags, mode = self._get_app_flags_mode(self.rest(1)) # pylint: disable=protected-access
    if 'f' not in flags:
        flags += 'f'
    self.fm.execute_file(
        files=[f for f in self.fm.thistab.get_selection()],
        app=app,
        flags=flags,
        mode=mode)

open_with.execute = execute
