#!/usr/bin/env -S v run

// install v dependencies
execute("v install")
execute("v install --git https://github.com/vpkgs/cmark_gfm")

// install cmark-gfm
execute("git clone https://github.com/github/cmark-gfm.git")