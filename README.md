# base2base

## Presentation

Convert strings representing numbers between different bases.

## Usage

You should not use base36. But let's say you have legacy code to work with
and need to convert binary from and to base36:

    local base2base = require "base2base"
    local alphabet_b36 = base2base.ALPHABET_B62:sub(1,36)
    local from_b36 = base2base.converter(alphabet_b36, base2base.ALPHABET_B256)
    local to_b36 = base2base.converter(base2base.ALPHABET_B256, alphabet_b36)
    local bin = from_b36("yolo42")
    assert(to_b36(bin) == "yolo42")

For hexadecimal, there are faster functions available directly in the module.

    local bin = base2base.from_hex("1234dead")
    assert(base2base.to_hex(bin) == "1234dead")

There are also helpers for base36, so you can do this:

    local bin = base2base.from_b36("yolo42")
    assert(base2base.to_b36(bin) == "yolo42")

Finally, there are helpers for padded base64:

    base2base.to_b64("Ma") -- "TWE="
    base2base.from_b64("TWE=") -- "Ma"

## Copyright

Copyright (c) 2016 Pierre Chapuis
