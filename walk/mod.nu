# An simple and opinionated bookmark-like module to get around your system fast.

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
export def add [
	name: string # The name of the new bookmark
	path: path # The path of the new bookmark
]: nothing -> nothing {
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

# Walking to a predefined bookmark
export def --env via [
	name: string@bookmarks # The bookmark to walk into
]: nothing -> nothing {
	list
	| where {|r| $r.name == $name}
	| get path
	| get 0
	| cd $in
}

# Printing an help message
export def main []: nothing -> nothing {
	print -n (help walk)
}