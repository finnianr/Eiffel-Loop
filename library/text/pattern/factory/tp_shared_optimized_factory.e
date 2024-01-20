note
	description: "Shared instance of object conforming to ${TP_OPTIMIZED_FACTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

deferred class
	TP_SHARED_OPTIMIZED_FACTORY

inherit
	EL_ANY_SHARED

	EL_SHARED_CLASS_ID

feature {NONE} -- Implementation

	optimal_core (text: READABLE_STRING_GENERAL): TP_OPTIMIZED_FACTORY
		-- optimal `core' pattern factory for `text' type
		do
			inspect Class_id.character_bytes (text)
				when '1' then
					Result := Factory_readable_string_8
				when '4' then
					Result := factory_general
				when 'X' then
					Result := Factory_zstring
			end
		end

feature {NONE} -- Constants

	Factory_general: TP_OPTIMIZED_FACTORY
		once ("PROCESS")
			create Result
		end

	Factory_readable_string_8: TP_RSTRING_OPTIMIZED_FACTORY
		once ("PROCESS")
			create Result
		end

	Factory_zstring: TP_ZSTRING_OPTIMIZED_FACTORY
		once ("PROCESS")
			create Result
		end

end