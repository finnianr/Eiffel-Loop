note
	description: "[
		Object to translate foreign attribute names to the standard Eiffel snake-case convention and also
		to export snake-case name to a foreign convention.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-23 9:29:29 GMT (Saturday 23rd December 2023)"
	revision: "10"

deferred class
	EL_NAME_TRANSLATER

inherit
	EL_NAMING_ROUTINES
		export
			{NONE} all
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			if attached uppercase_exception_set_list as set_list then
				set_uppercase_exception_set (set_list)
			else
				uppercase_exception_set := empty_word_set
			end
		end

	make
		do
			make_case (Default_case)
		end

	make_case (case: NATURAL_8)
		require
			valid_case: (create {EL_CASE}).is_valid (case)
		do
			default_create
			foreign_case := case
		end

feature -- Element change

	set_uppercase_exception_set (csv_list: STRING)
		local
			words: EL_STRING_8_LIST
		do
			words := csv_list
			uppercase_exception_set := words.to_array
		end

feature -- Conversion

	exported (eiffel_name: READABLE_STRING_8): STRING
		-- `eiffel_name' exported to a foreign naming convention
		deferred
		ensure
			new_instance: Result /= eiffel_name
		end

	imported (foreign_name: READABLE_STRING_8): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		deferred
		ensure
			new_instance: Result /= foreign_name
		end

feature -- Element change

	inform (eiffel_name: IMMUTABLE_STRING_8)
		-- useful for camelCase descendant
		do
		end

feature {NONE} -- Implementation

	uppercase_exception_set_list: detachable STRING
		-- comma separated list of exceptions to initialized `uppercase_exception_set'
		do
			Result := Void
		end

feature {NONE} -- Internal attributes

	foreign_case: NATURAL

	uppercase_exception_set: EL_HASH_SET [STRING]
		-- set of words to be fully upper-cased for title case

feature {NONE} -- Constants

	Default_case: NATURAL_8
		once
			Result := {EL_CASE}.default
		end

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

note
	descendants: "[
			EL_NAME_TRANSLATER*
				[$source EL_KEBAB_CASE_TRANSLATER]
					[$source EL_HTTP_HEADER_NAME_TRANSLATER]
				[$source EL_SNAKE_CASE_TRANSLATER]
				[$source EL_CAMEL_CASE_TRANSLATER]
					[$source PP_NAME_TRANSLATER]
				[$source EL_ENGLISH_NAME_TRANSLATER]
					[$source TL_MUSICBRAINZ_TRANSLATER]
	]"
end