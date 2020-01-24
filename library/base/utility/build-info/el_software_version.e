note
	description: "Software version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 11:00:24 GMT (Thursday 3rd October 2019)"
	revision: "9"

class
	EL_SOFTWARE_VERSION

inherit
	ANY
		redefine
			out
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (a_compact_version, a_build: NATURAL)
			--
		do
			compact_version := a_compact_version; build := a_build
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

end
