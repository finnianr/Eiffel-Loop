note
	description: "Abstraction for VTD native xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 11:01:10 GMT (Saturday 15th January 2022)"
	revision: "6"

deferred class
	EL_VTD_NATIVE_XPATH_I [T]

inherit
	TO_SPECIAL [T]
		export
			{NONE} area
		end

	EL_STRING_32_CONSTANTS

feature {NONE} -- Initialization

	make_empty
		do
			make (Empty_string_32)
		end

	make (xpath: READABLE_STRING_GENERAL)
		local
			buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			if attached {STRING_32} xpath as str_32 then
				share_area (str_32)

			elseif attached buffer.copied_general (xpath) as str_32 then
				if {PLATFORM}.is_windows then
					share_area (str_32)
				else
					share_area (str_32.twin)
				end
			end
		end

feature -- Element change

	share_area (a_xpath: STRING_32)
			-- Platform specific
		deferred
		ensure
			null_terminated: area [a_xpath.count] = null_terminator
		end

feature -- Access

	base_address: POINTER
		do
			Result := area.base_address
		end

feature {NONE} -- Implementation

	null_terminator: T
		deferred
		end
end