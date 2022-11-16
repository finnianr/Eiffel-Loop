note
	description: "Common phrases and titles accessible via [$source EL_SHARED_PHRASE] as `Phrase'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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

feature {NONE} -- Constants

	English_table: STRING = "[
		are_you_sure:
			Are you sure?
		mkdir_permission_denied:
			You don't have permission to create this directory here.
		file_open_permission_denied:
			There was a problem to put this file in the directory specified.
	]"
end