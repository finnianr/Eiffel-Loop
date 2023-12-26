note
	description: "[
		Factory for [$source EL_FORMAT_DOUBLE] and [$source EL_FORMAT_INTEGER] formats
		initialized using format likeness strings. Accessible via [$source EL_SHARED_FORMAT_FACTORY].
		See class [$source EL_FORMAT_LIKENESS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:29:39 GMT (Monday 25th December 2023)"
	revision: "4"

class
	EL_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			create double_cache.make (5, agent new_format_double)
			create integer_cache.make (5, agent new_format_integer)
		end

feature -- Access

	double (likeness: STRING): EL_FORMAT_DOUBLE
		do
			Result := double_cache.item (likeness)
		end

	double_as_string (d: DOUBLE; likeness: STRING): STRING
		do
			Result := double (likeness).formatted (d)
		end

	found_double: EL_FORMAT_DOUBLE
		do
			Result := double_cache.found_item
		end

	integer (likeness: STRING): EL_FORMAT_INTEGER
		do
			Result := integer_cache.item (likeness)
		end

	integer_as_string (n: INTEGER; likeness: STRING): STRING
		do
			Result := integer (likeness).formatted (n)
		end

feature -- Status query

	has_double_key (likeness: STRING): BOOLEAN
		do
			Result := double_cache.has_key (likeness)
		end

feature {NONE} -- Implementation

	new_format_double (likeness: STRING): EL_FORMAT_DOUBLE
		do
			Result := likeness
		end

	new_format_integer (likeness: STRING): EL_FORMAT_INTEGER
		do
			Result := likeness
		end

feature {NONE} -- Internal attributes

	double_cache: EL_AGENT_CACHE_TABLE [EL_FORMAT_DOUBLE, STRING]

	integer_cache: EL_AGENT_CACHE_TABLE [EL_FORMAT_INTEGER, STRING]

end