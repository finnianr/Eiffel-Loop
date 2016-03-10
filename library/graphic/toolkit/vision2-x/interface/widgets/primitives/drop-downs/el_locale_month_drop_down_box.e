note
	description: "Summary description for {INTERNATIONAL_MONTH_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-01-07 11:26:09 GMT (Monday 7th January 2013)"
	revision: "2"

class
	EL_LOCALE_MONTH_DROP_DOWN_BOX

inherit
	EL_MONTH_DROP_DOWN_BOX
		redefine
			Months_text, Long_months_text
		end

	EL_MODULE_LOCALE
		undefine
			default_create, is_equal, copy
		end

create
	make, make_long

feature {NONE} -- Implementation

	Months_text: ARRAY [STRING]
			-- Short text representation of months
		once
			Result := Locale.translation_array (Precursor)
		end

	Long_months_text: ARRAY [STRING]
			-- Long text representation of months
		once
			Result := Locale.translation_array (Precursor)
			Result [5] := Locale * "MAY.long"
		end

end
