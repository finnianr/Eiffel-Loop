note
	description: "Microsoft compiler options"
	notes: "[
		Port of Python class `eiffel_loop.C_util.C_dev.MICROSOFT_COMPILER_OPTIONS'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 10:54:22 GMT (Friday 4th October 2024)"
	revision: "2"

class
	MICROSOFT_COMPILER_OPTIONS

inherit
	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_architecture, a_build_type, a_compatibility, a_app_compat_flags: STRING)
		do
			set_architecture (a_architecture); set_build_type (a_build_type)
			set_compatibility (a_compatibility)
			app_compat_flags := a_app_compat_flags
		end

	make_default
		do
			make ("x64", "Release", "win7", "")
		end

feature -- Access

	app_compat_flags: STRING

	architecture: STRING

	build_type: STRING

	compatibility: STRING

feature -- Element change

	set_app_compat_flags (a_app_compat_flags: STRING)
		do
			app_compat_flags := a_app_compat_flags
		end

	set_architecture (a_architecture: STRING)
		require
			valid_architecture: Valid_architectures.has (a_architecture)
		do
			architecture := a_architecture
		end

	set_build_type (a_build_type: STRING)
		require
			valid_build_type: Valid_build_types.has (a_build_type)
		do
			build_type := a_build_type
		end

	set_compatibility (a_compatibility: STRING)
		require
			valid_compatibility: Valid_compatibility_options.has (a_compatibility)
		do
			compatibility := a_compatibility
		end

feature -- Conversion

	as_switch_string: STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			create Result.make_empty
			if attached {EL_ARRAYED_LIST [STRING]} value_list_for_type ({STRING}) as value_list then
				value_list.prune (app_compat_flags)
				if attached {LIST [STRING]} value_list.derived_list (agent as_switch) as switch_list then
					Result := s.joined_list (switch_list, ' ')
				end
			end
		end

feature -- Constants

	Valid_architectures: EL_STRING_8_LIST
		once
			Result := "x86, x64, ia64"
		end

	Valid_build_types: EL_STRING_8_LIST
		once
			Result := "Debug, Release"
		end

	Valid_compatibility_options: EL_STRING_8_LIST
		once
			Result := "2003, 2008, vista, win7, xp"
		end

feature {NONE} -- Implementation

	as_switch (option: STRING): STRING
		do
			Result := "/" + option
		end
end