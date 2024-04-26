note
	description: "Windows implementation of ${EL_MAKE_DIRECTORY_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-26 8:09:59 GMT (Friday 26th April 2024)"
	revision: "9"

class
	EL_MAKE_DIRECTORY_COMMAND_IMP

inherit
	EL_MAKE_DIRECTORY_COMMAND_I
		export
			{NONE} all
		redefine
			execute
		end

	EL_OS_COMMAND_IMP
		undefine
			execute
		end

	EL_SHARED_DIRECTORY

create
	make, make_default

feature -- Basic operations

	execute
		-- simulate behaviour of Unix command `mkdir --parents' with recursion
		do
			if not directory_path.exists and then attached directory_path.parent as parent_dir then
				if attached directory_path as sub_dir then
					directory_path := parent_dir
					execute -- recursive
					directory_path := sub_dir
				end
				if parent_dir.exists_and_is_writeable then
					Precursor
				end
			end
		end

	execute_x
		-- simulate behaviour of Unix command `mkdir --parents' with recursion
		do
			if not directory_path.exists then
				if directory_path.has_parent and then attached directory_path.parent as parent_dir
					and then not parent_dir.exists
				then
					if attached directory_path as sub_dir then
						directory_path := parent_dir
						execute -- recursive
						directory_path := sub_dir
					end
					Precursor
				else
					Precursor
				end
			end
		end

feature {NONE} -- Constants

	Template: STRING = "mkdir $directory_path"
end