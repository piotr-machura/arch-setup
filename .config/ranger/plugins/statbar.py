"""Most of this is copied from
/usr/lib/python3.8/site-packages/ranger/gui/widgets/statusbar.py

Some things were removed to declutter the ranger status bar
"""
import os
from os import getuid, readlink
from ranger.gui.widgets.statusbar import StatusBar, get_free_space
from ranger.ext.human_readable import human_readable
#pylint: disable=blacklisted-name,protected-access,too-many-branches,too-many-statements

def _get_left_part(self, bar):
    left = bar.left

    if self.column is not None and self.column.target is not None \
            and self.column.target.is_directory:
        target = self.column.target.pointed_obj
    else:
        directory = self.fm.thistab.at_level(0)
        if directory:
            target = directory.pointed_obj
        else:
            return
    try:
        stat = target.stat
    except AttributeError:
        return
    if stat is None:
        return

    if self.fm.mode != 'normal':
        perms = '--%s--' % self.fm.mode.upper()
    else:
        perms = target.get_permission_string()
    how = 'good' if getuid() == stat.st_uid else 'bad'
    left.add(perms, 'permissions', how)
    #! removed nlink
    left.add_space()
    left.add(self._get_owner(target), 'owner')
    #! removed group display
    if target.is_link:
        how = 'good' if target.exists else 'bad'
        try:
            dest = readlink(target.path)
        except OSError:
            dest = '?'
        left.add(' -> ' + dest, 'link', how)
    else:
        left.add_space()

        if self.settings.display_size_in_status_bar and target.infostring:
            left.add(target.infostring.replace(" ", ""))
            left.add_space()

    #! removed last time edited

    directory = target if target.is_directory else \
        target.fm.get_directory(os.path.dirname(target.path))
    if directory.vcs and directory.vcs.track:
        #! Changed how VCS info is displayed
        if directory.vcs.rootvcs.branch:
            vcsinfo = f' {directory.vcs.rootvcs.branch}'
        else:
            vcsinfo = f' {directory.vcs.rootvcs.repotype}'
        left.add_space()
        left.add(vcsinfo, 'vcsinfo')

        left.add_space()
        if directory.vcs.rootvcs.obj.vcsremotestatus:
            vcsstr, vcscol = self.vcsremotestatus_symb[
                directory.vcs.rootvcs.obj.vcsremotestatus]
            left.add(vcsstr.strip(), 'vcsremote', *vcscol)
        if target.vcsstatus:
            vcsstr, vcscol = self.vcsstatus_symb[target.vcsstatus]
            left.add(vcsstr.strip(), 'vcsfile', *vcscol)


def _get_right_part(self, bar):
    right = bar.right
    if self.column is None:
        return

    target = self.column.target
    if target is None \
            or not target.accessible \
            or (target.is_directory and target.files is None):
        return

    pos = target.scroll_begin
    max_pos = len(target) - self.column.hei
    base = 'scroll'

    right.add(" ", "space")

    if self.fm.thisdir.flat:
        right.add("flat=", base, 'flat')
        right.add(str(self.fm.thisdir.flat), base, 'flat')
        right.add(", ", "space")

    if self.fm.thisdir.narrow_filter:
        right.add("narrowed")
        right.add(", ", "space")

    if self.fm.thisdir.filter:
        right.add("f=`", base, 'filter')
        right.add(self.fm.thisdir.filter.pattern, base, 'filter')
        right.add("', ", "space")

    if target.marked_items:
        if len(target.marked_items) == target.size:
            right.add(human_readable(target.disk_usage, separator=''))
        else:
            sumsize = sum(f.size for f in target.marked_items
                            if not f.is_directory
                            or f.cumulative_size_calculated)
            right.add(human_readable(sumsize, separator=''))
        right.add(" in " + str(len(target.marked_items)) + " files")
    else:
        if self.settings.display_free_space_in_status_bar:
            try:
                free = get_free_space(target.path)
            except OSError:
                pass
            else:
                right.add(", ", "space")
                right.add(human_readable(free, separator='') + " free")
    right.add("  ", "space")

    if target.marked_items:
        # Indicate that there are marked files. Useful if you scroll
        # away and don't see them anymore.
        right.add('Mrk', base, 'marked')
    elif target.files:
        right.add(str(target.pointer + 1) + '/' + str(len(target.files)), base)
        if max_pos >=0 or pos != 0 or pos <=max_pos:
            right.add('{0:0.0%}'.format((pos / max_pos)),
                        base, 'percentage')

    if self.settings.freeze_files:
        # Indicate that files are frozen and will not be loaded
        right.add("  ", "space")
        right.add('FROZEN', base, 'frozen')

StatusBar._get_left_part = _get_left_part
StatusBar._get_right_part = _get_right_part
