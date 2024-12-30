# base2base

![CI Status](https://github.com/oploadk/base2base/actions/workflows/ci.yml/badge.svg?branch=master)

## Presentation

Convert strings representing numbers between different bases.

## Dependencies

None except Teal or Lua 5.3+.

Tests require [cwtest](https://github.com/catwell/cwtest).

## Usage

You should not use base36. But let's say you have legacy code to work with
and need to convert binary from and to base36:

    local base2base = require "base2base"
    local alphabet_b36 = base2base.ALPHABET_B62:sub(1,36)
    local from_b36 = base2base.converter(alphabet_b36, base2base.ALPHABET_B256)
    local to_b36 = base2base.converter(base2base.ALPHABET_B256, alphabet_b36)
    local bin = from_b36("yolo42")
    assert(to_b36(bin) == "yolo42")

You can also use the library to check if the string is a valid representation
for a given base:

    assert(from_b36:validate("f00b4r"))
    assert(not from_b36:validate("f00+b4r"))

For hexadecimal, there are faster functions available directly in the module.

    local bin = base2base.from_hex("1234dead")
    assert(base2base.to_hex(bin) == "1234dead")
    assert(base2base.is_hex("1234dead"))

There are also helpers for base36, so you can do this:

    local bin = base2base.from_b36("yolo42")
    assert(base2base.to_b36(bin) == "yolo42")
    assert(base2base.is_b36("yolo42"))

Finally, there are helpers for padded base64 and its base64 URL variant:

    base2base.to_b64("Ma") -- "TWE="
    base2base.from_b64("TWE=") -- "Ma"
    base2base.to_b64url("Ma") -- "TWE="
    base2base.from_b64url("TWE=") -- "Ma"

There are no `is_*` validation helpers for base64.

## Copyright

Copyright (c) Pierre Chapuis
