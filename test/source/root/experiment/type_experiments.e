note
	description: "Type experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 11:42:30 GMT (Tuesday 21st January 2020)"
	revision: "4"

class
	TYPE_EXPERIMENTS

inherit
	EXPERIMENTAL

	EL_SHARED_MAKEABLE_FACTORY

feature -- Basic operations

	conforming_types
		do
			if {ISE_RUNTIME}.type_conforms_to (
				({EL_STANDARD_UNINSTALL_APP}).type_id, ({EL_INSTALLABLE_SUB_APPLICATION}).type_id
				) then
				lio.put_line ("Conforms")
			end
		end

	generic_type_check
		local
			list: LIST [STRING_GENERAL]
			type: TYPE [ANY]
		do
			create {EL_ZSTRING_LIST} list.make (0)
			type := list.generating_type.generic_parameter_type (1)
		end

	generic_types
		local
			type_8, type_32: TYPE [LIST [READABLE_STRING_GENERAL]]
		do
			type_8 := {ARRAYED_LIST [STRING]}
			type_32 := {ARRAYED_LIST [STRING_32]}
		end

	valid_class_name
		do
			lio.put_labeled_string ("FFT_COMPLEX_DOUBLE", Factory.valid_name ("FFT_COMPLEX_64").out)
			lio.put_new_line
		end

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EROS_REMOTELY_ACCESSIBLE]
			--
		once
			create Result
		end
end
