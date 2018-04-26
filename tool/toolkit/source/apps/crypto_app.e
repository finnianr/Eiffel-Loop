note
	description: "[
		Menu driven shell of various cryptographic funtions. These are listed in function
		{[$source EL_CRYPTO_COMMAND_SHELL]}.new_command_table
		
		Usage: `el_toolkit -crypto'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-19 9:41:00 GMT (Thursday 19th April 2018)"
	revision: "7"

class
	CRYPTO_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name
		end

feature {NONE} -- Constants

	Option_name: STRING = "crypto"

	Description: STRING = "Menu driven cryptographic tool"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CRYPTO_APP}, All_routines]
			>>
		end
end
