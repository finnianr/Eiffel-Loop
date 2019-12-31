note
	description: "Application command line options (copied from Matryoshka app)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 12:18:51 GMT (Tuesday 31st December 2019)"
	revision: "4"

class
	APPLICATION_COMMAND_OPTIONS

inherit
	EL_BASE_COMMAND_OPTIONS

create
	make

feature -- Constants

	options_list: ARRAY [STRING]
		do
			Result := << Opt_silent, "config", File_placeholder >>
		end

feature {NONE} -- Constants

	File_placeholder: STRING = "%%f"

end
