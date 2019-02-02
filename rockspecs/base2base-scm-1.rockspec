package = "base2base"
version = "scm-1"

source = {
    url = "git://github.com/oploadk/base2base.git",
}

description = {
    summary = "A base-to-base converter",
    detailed = [[
        Convert strings representing numbers between different bases.
    ]],
    homepage = "http://github.com/oploadk/base2base",
    license = "MIT/X11",
}

dependencies = { "lua >= 5.3" }

build = {
    type = "none",
    install = { lua = {base2base = "base2base.lua"} },
    copy_directories = {},
}
