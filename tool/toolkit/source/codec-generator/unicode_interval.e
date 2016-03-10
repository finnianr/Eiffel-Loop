note
	description: "Summary description for {UNICODE_INTERVAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNICODE_INTERVAL

inherit
	INTEGER_INTERVAL
		rename
			make as make_interval
		end

	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal, copy
		end

	COMPARABLE
		undefine
			is_equal, copy
		end

create
	make

convert
	make ({INTEGER_INTERVAL})

feature {NONE} -- Initialization

	make (a_interval: INTEGER_INTERVAL)
		do
			make_interval (a_interval.lower, a_interval.upper)
			make_eiffel_context
			create latin_characters.make (7)
		end

feature -- Access

	latin_characters: ARRAYED_LIST [LATIN_CHARACTER]

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := count > other.count
		end

feature -- Status query


feature -- Element change

	extend_latin (c: LATIN_CHARACTER)
		do
			latin_characters.extend (c)
		end

feature {NONE} -- Implementation

	character (code: NATURAL): EL_ASTRING
		do
			create Result.make (1)
			Result.append_unicode (code)
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["lower_character", agent: EL_ASTRING do Result := character (lower.to_natural_32) end ],
				["upper_character", agent: EL_ASTRING do Result := character (upper.to_natural_32) end ],
				["first_latin_character", agent: LATIN_CHARACTER do Result := latin_characters.first end],
				["latin_characters", agent: ITERABLE [LATIN_CHARACTER] do Result := latin_characters end]
			>>)
		end

end
