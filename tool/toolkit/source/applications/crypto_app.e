note
	description: "[
		Menu driven shell of various cryptographic funtions. These are listed in function
		{[../../../../library/text/encryption/rsa/el_crypto_command_shell.html EL_CRYPTO_COMMAND_SHELL]}.new_command_table
		
		Usage: `el_toolkit -crypto'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 16:40:00 GMT (Sunday 28th May 2017)"
	revision: "3"

class
	CRYPTO_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATTION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make_shell
		end

feature {NONE} -- Constants

	Option_name: STRING = "crypto"

	Description: STRING = "Menu driven cryptographic tool"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{CRYPTO_APP}, "*"]
			>>
		end
end
