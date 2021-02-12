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
	date: "2021-02-12 14:34:49 GMT (Friday 12th February 2021)"
	revision: "13"

class
	CRYPTO_COMMAND_SHELL_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name, visible_types
		end

feature {NONE} -- Implementation

	visible_types: TUPLE [EL_X509_KEY_READER_COMMAND_IMP]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Menu driven cryptographic tool"

	Option_name: STRING = "crypto"

end