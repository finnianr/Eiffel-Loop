note
	description: "Shared instance of object conforming to [$source TP_OPTIMIZED_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 17:25:17 GMT (Sunday 12th November 2023)"
	revision: "8"

deferred class
	TP_SHARED_OPTIMIZED_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	optimal_core (text: READABLE_STRING_GENERAL): TP_OPTIMIZED_FACTORY
		-- optimal `core' pattern factory for `text' type
		do
			if text.is_string_8 then
				Result := Factory_readable_string_8

			elseif attached {EL_READABLE_ZSTRING} text then
				Result := Factory_zstring

			else
				Result := factory_general
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