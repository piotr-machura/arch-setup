#!/usr/bin/python
# coding=UTF-8
"""Custom VCS NERD font status icons. Refer to a dictionary in
/usr/lib/python3.8/site-packages/ranger/gui/widgets
for any future changes."""

from ranger.gui.widgets import Widget

Widget.vcsstatus_symb['conflict'] = ('! ', ['vscconflict'])
Widget.vcsstatus_symb['untracked'] = ('? ', ['vsuntracked'])
Widget.vcsstatus_symb['deleted'] = (' ', ['vscchanged'])
Widget.vcsstatus_symb['changed'] = ('* ', ['vscchanged'])
Widget.vcsstatus_symb['staged'] = (' ', ['vscstaged'])
Widget.vcsstatus_symb['igonred'] = ('  ', ['vscignored'])
Widget.vcsstatus_symb['sync'] = (' ', ['vscsync'])
Widget.vcsstatus_symb['none'] = ('', [])
Widget.vcsstatus_symb['unknown'] = (' ', ['vscunknown'])

Widget.vcsremotestatus_symb['diverged'] = ('⇕ ', ['vcsdiverged'] )
Widget.vcsremotestatus_symb['ahead'] = ('⇡ ', ['vcsahead'] )
Widget.vcsremotestatus_symb['behind'] = ('⇣ ', ['vcsbehind'] )
Widget.vcsremotestatus_symb['sync'] = ('', ['vcssync'])
Widget.vcsremotestatus_symb['none'] = ('', ['vcsnone'] )
Widget.vcsremotestatus_symb['diverged'] = (' ' , ['vcsunknown'] )
