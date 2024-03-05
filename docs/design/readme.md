# design of `walk`

## Decision to make

- [x] work with nuon
- [ ] work with database

## API / CLI Interface

What certain commands should do.

- `walk` [string]
  - printing a help message
- `walk via` [string]
  - walking to an already defined directory
- `walk new` [string] [path]
  - adding a new bookmark
- `walk delete` [string]
  - deleting an bookmark
- `walk reset`
  - delete all bookmarks
- `walk list`
  - list all bookmarks

## Notes:

- To change directorys in current shell via script you should use the `--env`
  flag in that function.

## Helpful ressource:

- https://github.com/nushell/nupm
- https://www.nushell.sh/book/modules.html#examples
- https://www.nushell.sh/book/custom_completions.html#custom-descriptions
- https://amtoine.github.io/posts/a-nu-alternative-to-the-old-makefile/
