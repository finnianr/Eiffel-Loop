note
	description: "Summary description for {EL_GPG_ENCRYPT_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_GPG_ENCRYPT_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_GPG_ENCRYPT_IMPL]
		rename
			path as output_path,
			set_path as set_output_path
		redefine
			output_path
		end

create
	make, make_default

feature -- Access

	output_path: EL_FILE_PATH

	recipient: STRING

feature -- Element change

	set_recipient (a_recipient: like recipient)
		do
			recipient := a_recipient
		end
end
