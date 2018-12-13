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
	date: "2018-06-19 10:43:46 GMT (Tuesday 19th June 2018)"
	revision: "9"

class
	CRYPTO_COMMAND_SHELL_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name
		end

feature {NONE} -- Constants

	Option_name: STRING = "crypto"

	Description: STRING = "Menu driven cryptographic tool"

end