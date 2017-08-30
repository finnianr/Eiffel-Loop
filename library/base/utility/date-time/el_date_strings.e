note
	description: "[
		For use by tool `el_eiffel -check_locale_strings' to check dates
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:17:07 GMT (Sunday 21st May 2017)"
	revision: "4"

class
	EL_DATE_STRINGS

feature

	Eng_ordinal_indicators: ARRAY [STRING]
		once
			Result := <<
				"{ordinal-indicator.0}",
				"{ordinal-indicator.1}",
				"{ordinal-indicator.2}",
				"{ordinal-indicator.3}"
			>>
		end

	Eng_may: STRING
		once
			Result := "{May}"
		end

	Eng_days_text: ARRAY [STRING]
		once
			Result := <<
				"Sun",
				"Mon",
				"Tue",
				"Wed",
				"Thu",
				"Fri",
				"Sat"
			>>
		end

	Eng_months_text: ARRAY [STRING]
		once
			Result := <<
				"Jan",
				"Feb",
				"Mar",
				"Apr",
				"May",
				"Jun",
				"Jul",
				"Aug",
				"Sep",
				"Oct",
				"Nov",
				"Dec"
			>>
		end

	Eng_long_days_text: ARRAY [STRING]
		once
			Result := <<
				"Sunday",
				"Monday",
				"Tuesday",
				"Wednesday",
				"Thursday",
				"Friday",
				"Saturday"
			>>
		end

	Eng_long_months_text: ARRAY [STRING]
		once
			Result := <<
				"January",
				"February",
				"March",
				"April",
				"May",
				"June",
				"July",
				"August",
				"September",
				"October",
				"November",
				"December"
			>>
		end

end
