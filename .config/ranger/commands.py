from ranger.api.commands import Command
# Override open_with to always fork the process
class open_with(Command):

    def execute(self):
        app, flags, mode = self._get_app_flags_mode(self.rest(1))
        if 'f' not in flags:
            flags += 'f'
        self.fm.execute_file(
            files=[f for f in self.fm.thistab.get_selection()],
            app=app,
            flags=flags,
            mode=mode)

    def tab(self, tabnum):
        return self._tab_through_executables()

    def _get_app_flags_mode(self, string):  # pylint: disable=too-many-branches,too-many-statements
        """Extracts the application, flags and mode from a string.

        examples:
        "mplayer f 1" => ("mplayer", "f", 1)
        "atool 4" => ("atool", "", 4)
        "p" => ("", "p", 0)
        "" => None
        """

        app = ''
        flags = ''
        mode = 0
        split = string.split()

        if len(split) == 1:
            part = split[0]
            if self._is_app(part):
                app = part
            elif self._is_flags(part):
                flags = part
            elif self._is_mode(part):
                mode = part

        elif len(split) == 2:
            part0 = split[0]
            part1 = split[1]

            if self._is_app(part0):
                app = part0
                if self._is_flags(part1):
                    flags = part1
                elif self._is_mode(part1):
                    mode = part1
            elif self._is_flags(part0):
                flags = part0
                if self._is_mode(part1):
                    mode = part1
            elif self._is_mode(part0):
                mode = part0
                if self._is_flags(part1):
                    flags = part1

        elif len(split) >= 3:
            part0 = split[0]
            part1 = split[1]
            part2 = split[2]

            if self._is_app(part0):
                app = part0
                if self._is_flags(part1):
                    flags = part1
                    if self._is_mode(part2):
                        mode = part2
                elif self._is_mode(part1):
                    mode = part1
                    if self._is_flags(part2):
                        flags = part2
            elif self._is_flags(part0):
                flags = part0
                if self._is_mode(part1):
                    mode = part1
            elif self._is_mode(part0):
                mode = part0
                if self._is_flags(part1):
                    flags = part1

        return app, flags, int(mode)

    def _is_app(self, arg):
        return not self._is_flags(arg) and not arg.isdigit()

    @staticmethod
    def _is_flags(arg):
        from ranger.core.runner import ALLOWED_FLAGS
        return all(x in ALLOWED_FLAGS for x in arg)

    @staticmethod
    def _is_mode(arg):
        return all(x in '0123456789' for x in arg)
