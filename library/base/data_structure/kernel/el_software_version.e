note
	description: "Summary description for {EL_SOFTWARE_VERSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-04 10:02:14 GMT (Monday 4th September 2017)"
	revision: "3"

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
			number, scalar: NATURAL
		do
			compact_version := 0; scalar := 1_00_00
			across a_version.split ('.') as str loop
				number := str.item.to_natural_32
				compact_version := number * scalar + compact_version
				scalar := scalar // 100
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
			create list.make_from_array (<< major.out, minor.out, maintenance.out >>)
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
