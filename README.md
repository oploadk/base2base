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

## Copyright

Copyright (c) 2016 Pierre Chapuis
