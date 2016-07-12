note
	description: "Summary description for {CRYPTO_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:16:13 GMT (Friday 8th July 2016)"
	revision: "6"

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
