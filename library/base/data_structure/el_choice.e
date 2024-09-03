note
	description: "[
		Allows expression like: `choose [48, 24] #? Executable.is_finalized'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 10:46:16 GMT (Tuesday 3rd September 2024)"
	revision: "2"

expanded class
	EL_CHOICE [G]

feature -- Access

	item alias "[]" (false_item, true_item: G): EL_BOOLEAN_INDEXABLE [G]
		do
			create Result.make (false_item, true_item)
		end

end