note
	description: "Summary description for {CRYPTO_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "5"

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
				[{CRYPTO_APP}, "*"],
				[{EL_CRYPTO_COMMAND_SHELL}, "*"]
			>>
		end
end
