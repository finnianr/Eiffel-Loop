note
	description: "Summary description for {EL_SEND_MAIL_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 15:03:24 GMT (Thursday 24th December 2015)"
	revision: "4"

class
	EL_SEND_MAIL_COMMAND

inherit
	EL_OS_COMMAND [EL_SEND_MAIL_COMMAND_IMPL]
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create email_path
			create to_address.make_empty
			make_default
		end

feature -- Access

	email_path: EL_FILE_PATH

	to_address: ZSTRING

feature -- Element change

	set_email_path (a_email_path: like email_path)
		do
			email_path := a_email_path
		end

	set_to_address (a_to_address: like to_address)
		do
			to_address := a_to_address
		end

feature -- Basic operations

	send (email: EVOLICITY_SERIALIZEABLE_AS_XML)
		require
			email_path_set: not email_path.is_empty
			to_address_set: not to_address.is_empty
		local
			file_out: EL_PLAIN_TEXT_FILE
		do
			create file_out.make_open_write (email_path)
			file_out.set_encoding_from_other (email)
			across email.to_xml.lines as line loop
				file_out.put_string_z (line.item)
				file_out.put_character ('%R')
				file_out.put_new_line
			end
			file_out.close
			execute
			File_system.delete (email_path)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["email_path", agent: ZSTRING do Result := escaped_path (email_path) end],
				["to_address", agent: ZSTRING do Result := to_address end]
			>>)
		end
end
