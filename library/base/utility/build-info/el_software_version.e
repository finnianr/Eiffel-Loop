note
	description: "Software version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-26 17:01:20 GMT (Thursday 26th January 2023)"
	revision: "18"

class
	EL_SOFTWARE_VERSION

inherit
	COMPARABLE
		redefine
			out, is_equal
		end

	DEBUG_OUTPUT
		rename
			debug_output as out
		undefine
			is_equal
		redefine
			out
		end

create
	default_create, make, make_parts, make_from_string

convert
	make_from_string ({STRING})

feature -- Initialization

	make (a_compact_version, a_build: NATURAL)
			--
		do
			compact_version := a_compact_version; build := a_build
		end

	make_parts (a_major, a_minor, a_release, a_build: NATURAL)
		local
			array: EL_VERSION_ARRAY
		do
			create array.make_from_array (2, << a_major, a_minor, a_release >>)
			make (array.compact, a_build)
		end

	make_from_string (a_version: STRING)
		do
			set_from_string (a_version)
		end

feature -- Element change

	set_from_string (a_version: STRING)
		require
			valid_format: a_version.occurrences ('.') = 2
		local
			array: EL_VERSION_ARRAY
		do
			create array.make_from_string (2, a_version)
			make (array.compact, 0)
		end

feature -- Access

	out: STRING
			--
		do
			Result := string + " ("
			Result.append_natural_32 (build)
			Result.append_character (')')
		end

	string: STRING
		do
			Result := to_array.out
		end

	to_array: EL_VERSION_ARRAY
		do
			create Result.make (3, 2, compact_version)
		end

feature -- Access

	build: NATURAL
			--
	compact_version: NATURAL
			-- version in form jj_nn_tt where: jj is major version, nn is minor version and tt is maintenance version
			-- padded with leading zeros: eg. 01_02_15 is Version 1.2.15

	maintenance: NATURAL
			--
		do
			Result := compact_version \\ 100
		end

	major: NATURAL
			--
		do
			Result := compact_version // 10000
		end

	minor: NATURAL
			--
		do
			Result := compact_version // 100 \\ 100
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if compact_version = other.compact_version then
				Result := build < other.build
			else
				Result := compact_version < other.compact_version
			end
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := compact_version = other.compact_version and build = other.build
		end

end