# walk

A [nushell](https://www.nushell.sh) module to get around very quickly

## Install

### Download

`walk` is a nushell module, so to install it you must download the `walk`
directory and then add it in your `config.nu`.

For example I downloaded it and put it in a `module` folder under the
`$nu.default-config-dir`.

```
.
├── config.nu
├── env.nu
└── modules <- Put the contents in here.
```

So that it will look like the following:

```
.
├── config.nu
├── env.nu
└── modules
    └── walk <- The added folder
        └── mod.nu <- The added mod.nu file
```

Then you just need to add it with `use` in your `config.nu`:

```nushell
# config.nu

use ($nu.default-config-dir | path join modules/walk)
```

### With `nupm`

> [!WARNING]
> As [nupm](https://github.com/nushell/nupm) is currently not stable,
> it is not fully supported, but the needed `nupm.nuon` file exists. If nupm
> changes it status to stable, full `nupm` support will be added.

## Usage

> [!NOTE]
> All following example output will show how to output will look on Windows.

### Introduction:

We are currently in the `~` directory and want to add it to the Bookmark with
the name `home`:

```nushell
> walk add home .
```

Now you can see the full list:

```nushell
> walk list
╭───┬──────┬──────────────────╮
│ # │ name │      path        │
├───┼──────┼──────────────────┤
│ 0 │ home │ C:\<user>\<user> │
╰───┴──────┴──────────────────╯
```

To change your current directory to the `home` bookmark:
```nushell
> walk via home
```

To delete the bookmark `home`:

```nushell
> walk delete home
> walk list
╭────────────╮
│ empty list │
╰────────────╯
```

To reset the whole table:

```nushell
> walk add home .
> walk add projects ~\programming
> walk list
╭───┬──────────┬──────────────────────────────╮
│ # │   name   │            path              │
├───┼──────────┼──────────────────────────────┤
│ 0 │ home     │ C:\Users\<user>              │
│ 1 │ projects │ C:\Users\<user>\programming\ │
╰───┴──────────┴──────────────────────────────╯
> walk reset
> walk list
╭────────────╮
│ empty list │
╰────────────╯
```

### Commands:

Changing the directory to an bookmark:

```nushell
> walk via <name>
```

Adding an bookmark:

```nushell
> walk new <name> <path>
```

Deleting an bookmark:

```nushell
> walk delete <name>
```

Reseting all bookmarks:

```nushell
> walk reset
```

Showing all bookmarks:

```nushell
> walk list
```

## Saved File

The saved `bookmark.nuon` file can be either found in the `~/.local/share/walk`
path or in the path that is defined in the `WALK_PATH` environmental variable.

## FAQ

### Why is the command to change directorys called `walk via`?

The main problem with that command was that the alternatives `to` and `into`
already are used in nushell, so the `-h, --help` message would have looked
weird. And to fix it, the alternative to name the subcommand `via` was used.

### Why can I add two bookmarks with the same name?

The answer is that I could not be really bothered to add a function to check if
a name is already used. Regarding that, the first entry with the the found name
when calling the `walk via` command is used. So if we have the list:

```nushell
╭───┬──────┬──────────────────────────────╮
│ # │ name │            path              │
├───┼──────┼──────────────────────────────┤
│ 0 │ home │ C:\Users\<user>              │
│ 1 │ home │ C:\Users\<user>\programming\ │
╰───┴──────┴──────────────────────────────╯
```

You will **always** end in the `C:\Users\<user>` directory when using `walk via home`.

> [!IMPORTANT]
> When using `walk delete home` all entrie's with the name of `home`
> will get deleted.

### Can you change that all subcommands also print out the lists?

A could do that, but currently I think it is easier to not include it. Maybe I
will change this in the future.

> [!TIP]
> If you want to do it yourself, then change the return value of the subcommands
> `add`, `remove`, `reset` from `nothing -> nothing` to
> `nothing -> any, nothing -> table` and add the command call `list` at the end
> of every command.

## Alternative programs

- [bm](https://raw.githubusercontent.com/nushell/nu_scripts/main/modules/filesystem/bm.nu) -
  a bookmark module.

> [!IMPORTANT]
> please let me know of any other bookmark modules so I can put them in the list
> above
