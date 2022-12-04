note
	description: "Shared instance of object conforming to [$source TP_OPTIMIZED_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 18:05:13 GMT (Saturday 3rd December 2022)"
	revision: "6"

deferred class
	TP_SHARED_OPTIMIZED_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	optimal_core (text: READABLE_STRING_GENERAL): TP_OPTIMIZED_FACTORY
		-- optimal `core' pattern factory for `text' type
		do
			if attached {ZSTRING} text then
				Result := Factory_zstring

			elseif attached {READABLE_STRING_8} text then
				Result := Factory_readable_string_8

			else
				Result := factory_general
			end
		end

feature {NONE} -- Constants

	Factory_general: TP_OPTIMIZED_FACTORY
		once ("PROCESS")
			create Result
		end

	Factory_readable_string_8: TP_RSTRING_FACTORY
		once ("PROCESS")
			create Result
		end

	Factory_zstring: TP_ZSTRING_FACTORY
		once ("PROCESS")
			create Result
		end

end