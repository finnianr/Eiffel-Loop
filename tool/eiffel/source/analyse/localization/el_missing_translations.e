note
	description: "Missing translations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:19 GMT (Tuesday 18th March 2025)"
	revision: "7"

class
	EL_MISSING_TRANSLATIONS

inherit
	EVC_SERIALIZEABLE
		redefine
			getter_function_table, make_default
		end

create
	make_from_file

feature {NONE} -- Initialization

	make_default
		do
			create translation_keys.make_empty
			create class_name.make_empty
			Precursor
		end

feature -- Access

	translation_keys: EL_ZSTRING_LIST

	class_name: ZSTRING

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["translation_keys", agent: ITERABLE [ZSTRING] do Result := translation_keys end],
				["class_name", agent: ZSTRING do Result := class_name end]
			>>)
		end

feature {NONE} -- Implementation

	Template: STRING = "[
		pyxis-doc:
			version = 1.0; encoding = "UTF-8"
			
		# For class $class_name
		
		translations:
		#across $translation_keys as $key loop
			item:
				id = "$key.item"
				translation:
					lang = de; check = false
					""
				translation:
					lang = en
					"$$id"
		#end
	]"

end