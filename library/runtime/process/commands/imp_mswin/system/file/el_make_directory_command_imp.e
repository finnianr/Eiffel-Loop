note
	description: "Windows implementation of ${EL_MAKE_DIRECTORY_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-27 9:46:39 GMT (Friday 27th September 2024)"
	revision: "11"

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

create
	make, make_default

feature -- Basic operations

	execute
		-- simulate behaviour of Unix command `mkdir --parents' with recursion
		-- (will work with sudo on Windows)
		do
			if attached directory_path as path and then not path.is_empty
				and then not path.exists and then attached path.parent as parent_dir
			then
				if parent_dir.exists_and_is_writeable then
					Precursor -- mkdir
				else
					directory_path := parent_dir
					execute -- recurse
					directory_path := path
					if parent_dir.exists_and_is_writeable then
						Precursor -- mkdir
					else
						check
							parent_writeable: False
						end
					end
				end
			end
		end

feature {NONE} -- Constants

	Template: STRING = "mkdir $directory_path"
end