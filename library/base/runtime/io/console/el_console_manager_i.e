note
	description: "Console manager interface accessible via ${EL_MODULE_CONSOLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "18"

deferred class
	EL_CONSOLE_MANAGER_I

inherit
	EL_OS_DEPENDENT
	
	EL_SINGLE_THREAD_ACCESS

	EL_SHARED_BASE_OPTION

	EL_SYSTEM_ENCODINGS
		rename
			Console as Encoding
		export
			{NONE} all
			{ANY} Encoding
		end

feature {NONE} -- Initialization

	make
		do
			make_default
			create visible_types.make (20)
		end

feature -- Access

	code_page: STRING
		do
			Result := Encoding.code_page
		end

	decoded (input: READABLE_STRING_8): ZSTRING
		-- console `input' to `ZSTRING'
		do
			if is_utf_8_encoded then
				create Result.make_from_utf_8 (input)
			else
				Encoding.convert_to (Unicode, input)
				Result := Encoding.last_converted_string_32
			end
		end

	encoded (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): STRING
		-- string encoded for console
		do
			if attached Once_buffer as buffer then
				buffer.wipe_out
				buffer.put_string_general (str)
				if keep_ref then
					create Result.make_from_string (buffer.text)
				else
					Result := buffer.text
				end
			end
		end

feature -- Status change

	hide (type: TYPE [EL_MODULE_LIO])
			-- hide conditional `lio' output for type
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				visible_types.prune (type.type_id)
			end_restriction
		end

	show (type: TYPE [EL_MODULE_LIO])
			-- show conditional `lio' output for type
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				visible_types.put (type.type_id)
			end_restriction
		end

	show_all (type_list: ARRAY [TYPE [EL_MODULE_LIO]])
			-- show conditional `lio' output for all types
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				across type_list as type loop
					visible_types.put (type.item.type_id)
				end
			end_restriction
		end

feature -- Status query

	is_highlighting_enabled: BOOLEAN
			-- Can terminal color highlighting sequences be output to console
		deferred
		end

	is_type_visible (type: INTEGER): BOOLEAN
			--
		do
			restrict_access
				Result := visible_types.has (type)
			end_restriction
		end

	is_utf_8_encoded: BOOLEAN
		deferred
		end

feature {NONE} -- Internal attributes

	visible_types: EL_HASH_SET [INTEGER]

feature {NONE} -- Constants

	Once_buffer: EL_STRING_8_IO_MEDIUM
		once
			create Result.make (0)
			Result.set_encoding_other (Encoding)
		end
end