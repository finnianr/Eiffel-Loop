note
	description: "[
		Menu driven shell of various cryptographic funtions. These are listed in function
		{[../../../../library/text/encryption/rsa/el_crypto_command_shell.html EL_CRYPTO_COMMAND_SHELL]}.new_command_table
		
		Usage: `el_toolkit -crypto'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-25 10:55:16 GMT (Monday 25th July 2016)"
	revision: "1"

class
	CRYPTO_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATTION [EL_CRYPTO_COMMAND_SHELL]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
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
