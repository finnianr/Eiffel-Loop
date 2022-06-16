note
	description: "[
		Object to translate foreign attribute names to the standard Eiffel snake-case convention and also
		to export snake-case name to a foreign convention.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:37:14 GMT (Thursday 16th June 2022)"
	revision: "1"

deferred class
	EL_NAME_TRANSLATER

inherit
	ANY EL_MODULE_NAMING

feature {NONE} -- Initialization

	make
		do
			default_create
			foreign_case := Case_default
		end

	make_lower
		do
			default_create
			foreign_case := Case_lower
		end

	make_title
		do
			default_create
			foreign_case := Case_title
		end

	make_upper
		do
			default_create
			foreign_case := Case_upper
		end

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		deferred
		end

	imported (foreign_name: STRING): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		deferred
		end

feature -- Element change

	inform (eiffel_name: STRING)
		do
		end

feature {NONE} -- Internal attributes

	foreign_case: INTEGER

feature {NONE} -- Constants

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Case_default: INTEGER = 0

	Case_lower: INTEGER = 1

	Case_title: INTEGER = 3

	Case_upper: INTEGER = 2

note
	descendants: "[
			EL_NAME_TRANSLATER*
				[$source EL_KEBAB_CASE_TRANSLATER]
					[$source EL_HEADER_NAME_TRANSLATER]
				[$source EL_SNAKE_CASE_TRANSLATER]
				[$source EL_CAMEL_CASE_TRANSLATER]
				[$source EL_ENGLISH_NAME_TRANSLATER]
					[$source TL_MUSICBRAINZ_TRANSLATER]
	]"
end