#!/usr/bin/env bash
icdiff <(xmllint --format <(git show "$1":"$2")) <(xmllint --format <(git show "$3":"$4"))
