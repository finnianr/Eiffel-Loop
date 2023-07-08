note
	description: "Console manager interface accessible via [$source EL_MODULE_CONSOLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-08 18:21:48 GMT (Saturday 8th July 2023)"
	revision: "14"

deferred class
	EL_CONSOLE_MANAGER_I

inherit
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

	code_page: STRING_8
		do
			Result := Encoding.code_page
		end

	decoded (input: STRING_8): ZSTRING
		-- console `input' to `ZSTRING'
		do
			if is_utf_8_encoded then
				create Result.make_from_utf_8 (input)
			else
				Encoding.convert_to (Unicode, input)
				Result := Encoding.last_converted_string_32
			end
		end

	encoded (str: READABLE_STRING_GENERAL): STRING_8
		-- string encoded for console
		local
			l_encoding: ENCODING; done: BOOLEAN
		do
			if attached {EL_READABLE_ZSTRING} str as zstr then
				if is_utf_8_encoded then
					Result := zstr.to_utf_8 (True)
				else
					Result := encoded (zstr.to_general)
				end
			else
				if is_utf_8_encoded then
					l_encoding := Utf_8
				else
					l_encoding := Encoding
				end
				-- Fix for bug where LANG=C in Nautilus F10 terminal caused a crash
				from until done loop
					Unicode.convert_to (l_encoding, str)
					if Unicode.last_conversion_successful then
						done := True
					else
						l_encoding := Utf_8
					end
				end
				Result := Unicode.last_converted_string_8
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
end