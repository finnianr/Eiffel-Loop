note
	description: "[
		Command line interface to ${EL_CRYPTO_COMMAND_SHELL} class.
		This is a menu driven shell of various cryptographic functions listed in function
		`{EL_CRYPTO_COMMAND_SHELL}.new_command_table'
		
		Usage: `el_toolkit -crypto'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "19"

class
	CRYPTO_COMMAND_SHELL_APP

inherit
	EL_COMMAND_SHELL_APPLICATION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name, visible_types
		end

feature {NONE} -- Implementation

	visible_types: TUPLE [EL_X509_PRIVATE_READER_COMMAND_IMP]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "crypto"

end