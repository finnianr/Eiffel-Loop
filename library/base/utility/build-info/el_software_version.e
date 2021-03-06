note
	description: "Software version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-25 16:06:52 GMT (Friday 25th June 2021)"
	revision: "13"

class
	EL_SOFTWARE_VERSION

inherit
	COMPARABLE
		redefine
			out, is_equal
		end

create
	default_create, make, make_parts, make_from_string

convert
	make_from_string ({STRING})

feature {NONE} -- Initialization

	make (a_compact_version, a_build: NATURAL)
			--
		do
			compact_version := a_compact_version; build := a_build
		end

	make_parts (a_major, a_minor, a_release, a_build: NATURAL)
		do
			make (left_shift (a_major, 4) + left_shift (a_minor, 2) + a_release, a_build)
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
			number, scalar: NATURAL; digits: EL_SPLIT_STRING_LIST [STRING]
		do
			compact_version := 0; scalar := 1_00_00
			create digits.make (a_version, once ".")
			from digits.start until digits.after loop
				number := digits.natural_item
				compact_version := number * scalar + compact_version
				scalar := scalar // 100
				digits.forth
			end
		end

feature -- Access

	out: STRING
			--
		local
			template: ZSTRING
		do
			template := once "%S (%S)"
			Result := (template #$ [string, build]).to_string_8
		end

	string: STRING
		local
			list: EL_STRING_LIST [STRING]
		do
			create list.make_from_tuple ([major, minor, maintenance])
			Result := list.joined ('.')
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
			Result := compact_version  // 100 \\ 100
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := compact_version < other.compact_version
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := compact_version = other.compact_version
		end

feature {NONE} -- Implementation

	left_shift (value: NATURAL; n: INTEGER): NATURAL
		-- left shifted `value' by n decimal places
		local
			i: INTEGER
		do
			Result := value
			from i := 1 until i > n loop
				Result := Result * 10
				i := i + 1
			end
		end

end