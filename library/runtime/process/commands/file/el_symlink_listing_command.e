note
	description: "[
		Unix command to list symbolic links in a target directory
	]"
	notes: "[
		This is a stop-gap measure until a cross-platform class is created.
		See ''Future Development'' notes in [./library/os-command.html os-command.ecf library]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-25 9:35:38 GMT (Thursday 25th April 2024)"
	revision: "3"

class
	EL_SYMLINK_LISTING_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [target_path: STRING]]
		redefine
			do_with_lines
		end

create
	make

feature -- Access

	target_path: DIR_PATH

feature -- Element change

	set_target_path (a_target_path: DIR_PATH)
		do
			target_path := a_target_path
			put_path (var.target_path, a_target_path)
		end

feature {NONE} -- Implementation

	do_with_lines (list: like new_output_lines)
		do
			from list.start until list.after loop
				if attached list.item as line and then line.has_substring (Symlink_arrow)
					and then line.valid_index (Name_column)
				then
					lines.extend (line.substring_end (Name_column))
				end
				list.forth
			end
		end

feature {NONE} -- Constants

	Name_column: INTEGER = 40

	Symlink_arrow: ZSTRING
		once
			Result := " -> "
		end

	Template: STRING = "[
		ls -l $TARGET_PATH
	]"

end