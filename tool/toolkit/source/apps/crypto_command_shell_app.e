note
	description: "[
		Command line interface to [$source EL_CRYPTO_COMMAND_SHELL] class.
		This is a menu driven shell of various cryptographic functions listed in function
		`{[$source EL_CRYPTO_COMMAND_SHELL]}.new_command_table'
		
		Usage: `el_toolkit -crypto'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 11:57:32 GMT (Monday 2nd September 2019)"
	revision: "11"

class
	CRYPTO_COMMAND_SHELL_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name
		end

feature {NONE} -- Constants

	Description: STRING = "Menu driven cryptographic tool"

	Option_name: STRING = "crypto"

end
