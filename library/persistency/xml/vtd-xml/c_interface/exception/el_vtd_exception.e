note
	description: "${DEVELOPER_EXCEPTION} for VTD navigation and xpath parsing errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-19 17:05:49 GMT (Sunday 19th October 2025)"
	revision: "5"

class
	EL_VTD_EXCEPTION

inherit
	DEVELOPER_EXCEPTION
		rename
			message as developer_message,
			raise as raise_exception
		end

	EL_MODULE_EXCEPTION

create
	make_basic, make_full

feature {NONE} -- Initialization

	make_basic (a_exception_code: INTEGER; c_message: POINTER)
		do
			exception_code := a_exception_code
			create message.make_from_c (c_message)
			create sub_message.make_empty
		end

	make_full (a_exception_code: INTEGER; c_message, c_sub_message: POINTER)
		do
			make_basic (a_exception_code, c_message)
			create sub_message.make_from_c (c_sub_message)
		end

feature -- Access

	type_description: STRING
		do
	 		if attached Exception_enum.table as table and then table.has_key (code) then
		 		Result := table.found_item
		 	else
		 		Result := "unknown"
	 		end
		end

	error_label: STRING
		do
			Result := "VTD-XML " + type_description + " error"
		end

feature -- Conversion

	to_error: EL_ERROR_DESCRIPTION
		do
			create Result.make (error_label)
			Result.extend (message)
			if sub_message.count > 0 then
				Result.extend (sub_message)
			end
		end

feature -- Basic operations

	put_error (log: EL_LOGGABLE)
		do
			log.put_labeled_string (error_label, message)
			log.put_new_line
			if sub_message.count > 0 then
				log.put_line (sub_message)
			end
		end

	raise
		do
			Exception.raise (Current, Error_template, [type_description, message, sub_message])
		end

feature {NONE} -- Internal attributes

	exception_code: INTEGER

	message: STRING

	sub_message: STRING

feature {NONE} -- Constants

	Error_template: ZSTRING
		once
			Result := "VTD-XML %S error: %S (%S)"
		end
	Exception_enum: EL_VTD_EXCEPTION_ENUM
		once
			create Result
		end

end