note
	description: "Summary description for {EL_LOCALE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_LOCALE_ROUTINES

feature -- Conversion

	translation (key: STRING): STRING
			--
		local
			table: EL_TRANSLATION_TABLE
		do
			translations.lock
--			synchronized
				table := translations.item
				table.search (key)
				if table.found then
					Result := table.found_item
				else
					Result := key + "*"
				end
--			end
			translations.unlock
		end

	translation_array (keys: ARRAY [STRING]): ARRAY [STRING]
			--
		local
			i: INTEGER
		do
			create Result.make (keys.lower, keys.upper)
			from i := keys.lower until i > keys.count loop
				Result [i] := translation (keys [i])
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	translations: EL_SYNCHRONIZED [EL_TRANSLATION_TABLE]
			--
		note
			once_status: global
		once
			create Result
		end

end
