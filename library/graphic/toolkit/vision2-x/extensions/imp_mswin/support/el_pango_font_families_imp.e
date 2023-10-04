note
	description: "[
		Windows implementation of [$source EL_FONT_FAMILIES_I] for fonts compatible with Cairo Pango API compatible
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 5:23:48 GMT (Wednesday 2nd August 2023)"
	revision: "1"

class
	EL_PANGO_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_IMP
		redefine
			new_property_table
		end

feature {NONE} -- Implementation

	new_property_table: EL_IMMUTABLE_UTF_8_TABLE
		-- filter incompatible fonts from Precursor
		local
			invalid_set: EL_HASH_SET [IMMUTABLE_STRING_8]; cairo: CAIRO_DRAWING_CONTEXT_IMP
		do
			if attached Precursor as new_table then
				create cairo.make_default
				create invalid_set.make (new_table.count // 3)
				across new_table as table loop
					if not cairo.valid_font_family_utf_8 (table.key) then
						invalid_set.put (table.key)
					end
				end
				create Result.make_subset (new_table, invalid_set)
			end
		end
end
