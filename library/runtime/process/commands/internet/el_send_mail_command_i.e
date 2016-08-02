note
	description: "Summary description for {EL_SEND_MAIL_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 14:04:01 GMT (Thursday 23rd June 2016)"
	revision: "1"

deferred class
	EL_SEND_MAIL_COMMAND_I

inherit
	EL_OS_COMMAND_I
		export
			{NONE} all
		redefine
			is_asynchronous
		end

feature {NONE} -- Initialization

	make
		do
			create email_path
			create actual_log_path
			create to_address.make_empty
			make_default
		end

feature -- Access

	email_path: EL_FILE_PATH

	log_path: EL_FILE_PATH
		do
			if actual_log_path.is_empty then
				Result := email_path.with_new_extension ("log")
			else
				Result := actual_log_path
			end
		end

	to_address: ZSTRING

feature -- Element change

	set_email_path (a_email_path: like email_path)
		do
			email_path := a_email_path
		end

	set_log_path (a_log_path: like log_path)
		do
			actual_log_path := a_log_path
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
			File_system.make_directory (email_path.parent)
			File_system.make_directory (log_path.parent)

			create file_out.make_open_write (email_path)
			file_out.set_encoding_from_other (email)
			across email.to_xml.lines as line loop
				file_out.put_string_z (line.item)
				file_out.put_character ('%R')
				file_out.put_new_line
			end
			file_out.close
			execute
		end

feature -- Status query

	is_asynchronous: BOOLEAN
			--
		do
			Result := True
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["email_path", agent: ZSTRING do Result := escaped_path (email_path) end],
				["log_path", agent: ZSTRING do Result := escaped_path (log_path) end],
				["to_address", agent: ZSTRING do Result := to_address end]
			>>)
		end

feature {NONE} -- Implementation

	actual_log_path: EL_FILE_PATH

end