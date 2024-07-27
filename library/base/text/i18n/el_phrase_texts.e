note
	description: "Common phrases and titles accessible via ${EL_SHARED_PHRASE} as `Phrase'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-25 7:18:12 GMT (Thursday 25th July 2024)"
	revision: "5"

class
	EL_PHRASE_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			title_case_texts
		end

create
	make

feature -- Texts

	are_you_sure: ZSTRING

	confirmation_required: ZSTRING

	file_already_exists: ZSTRING

	file_open_permission_denied: ZSTRING

	file_creation_error: ZSTRING

	folder_creation_error: ZSTRING

	hit_return_to_finish: ZSTRING

	mkdir_permission_denied: ZSTRING

	there_is_a_problem: ZSTRING

feature {NONE} -- Implementation

	title_case_texts: like None
		do
			Result := << confirmation_required >>
		end

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				are_you_sure:
					Are you sure?
				mkdir_permission_denied:
					You don't have permission to create this directory here.
				file_open_permission_denied:
					There was a problem to put this file in the directory specified.
			]"
		end

end