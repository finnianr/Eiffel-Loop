note
	description: "Thunderbird email headers and content"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 18:04:52 GMT (Monday 23rd January 2023)"
	revision: "1"

class
	TB_EMAIL

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as kebab_case_title,
			field_included as is_any_field,
			make_default as make
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		end

create
	make

feature -- Access

	content: ZSTRING

	x_mozilla_status: NATURAL

	x_mozilla_draft_info: STRING

	FCC: STRING

	subject: STRING

feature {NONE} -- Constants

	Kebab_case_title: EL_NAME_TRANSLATER
		once
			Result := kebab_case_translater (Case.Title)
		end
end