# Function to get the bookmarks
def get_bookmarks []: nothing -> string {
	$env.WALK_PATH?
	| default (($nu.home-path? | path join ".local" "share" "walk"))
	| if (not ($in | path exists)) { mkdir $in; $in } else { $in }
	| path join "bookmarks.nuon"
}

# Function to save the bookmarks
def save_bookmarks []: any -> nothing {
	$in | save -f (get_bookmarks)
}

# creating a bookmark list for custom completion
def bookmarks []: nothing -> nothing {
	list
	| each {|r| { value: $r.name, description: $r.path }}
}

# List all bookmarks
export def list []: nothing -> any, nothing -> table {
	let pth = (get_bookmarks)
	if (not ($pth | path exists)) {
		[] | save $pth
	}
	open ($pth) | sort -v
}

# Creating an new bookmark
export def --env add [
	name: string = "c249b5de2ea666f161172e1810ca657a" # The name of the new bookmark
	path: path = "9a59318f8704dd710a5604f80fef368f" # The path of the new bookmark
]: nothing -> nothing {
	if $name == "c249b5de2ea666f161172e1810ca657a" {
		$name = ($env.PWD | split row "\\" | last)
	}
	if $path == "9a59318f8704dd710a5604f80fef368f" {
		$path = ($env.PWD)
	}

	if (list | get name | where {|x| $x == $name} | is-empty) {
		if (($path | path type) == "dir") and ($path | path exists) {
			list
			| append {name: ($name), path: ($path) }
			| save_bookmarks
		}
	} else {
		print $"The bookmark: \"(ansi yellow)($name)(ansi reset)\" already exists."
	}
}

# Deleting an bookmark
export def remove [
	name: string@bookmarks # The bookmarks to delete
]: nothing -> nothing {
	list
	| where {|r| not ($r.name == $name) }
	| save_bookmarks
}

# Renames a boolmark
export def rename [
	old_name: string@bookmarks # The bookmark to rename
	new_name: string # The new name for the bookmark
]: nothing -> nothing {
	if (list | is-empty) {
		print "You can not change a name, because there are no bookmarks."
	} else {
		if (list | get name | where {|x| $x == $new_name} | is-empty) {
			list
			| update cells -c ["name"] {|v|if $v == $old_name {$new_name} else {$v}}
			| save_bookmarks
		} else {
			print $"The bookmark: \"(ansi yellow)($new_name)(ansi reset)\" already exists."
		}
	}
}

# Reset all bookmarks
export def reset []: nothing -> nothing {
	(rm -f (get_bookmarks))
}

# An simple and opinionated bookmark-like module to get around your system fast.
export def --env main [
	name: string@bookmarks = "31230bb0f6c85deb56a950845515b39e"
]: nothing -> nothing {
	if $name != "31230bb0f6c85deb56a950845515b39e" {
		list
		| where {|r| $r.name == $name}
		| get path
		| get 0
		| cd $in
	} else {
		print ([
			"walk is an simple and opinionated bookmark-like module to get around your system fast."
			""
			$"(ansi green)Usage: (ansi blue)walk [SUBCOMMAND] [bookmark]:(ansi reset)"
			""
			$"(ansi green)Subcommands:(ansi reset)"
			$"    (ansi blue)add    (ansi reset) Add a new bookmark"
			$"    (ansi blue)list   (ansi reset) List all bookmarks"
			$"    (ansi blue)remove (ansi reset) Remove a bookmark"
			$"    (ansi blue)reset  (ansi reset) Reset all bookmarks \(All bookmarks get deleted)"
			$"    (ansi blue)rename (ansi reset) Rename a bookmark"
		]
		| str join "\n")
	}
}