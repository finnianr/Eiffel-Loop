note
	description: "Task config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 15:56:13 GMT (Sunday 1st September 2019)"
	revision: "2"

class
	TASK_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			name := "none"
			Precursor
		end

feature -- Access

	error_message: ZSTRING

	name: STRING

	volume: VOLUME_INFO

feature -- Status query

	is_dry_run: BOOLEAN

feature -- Status change

	enable_dry_run
		do
			is_dry_run := True
		end

feature -- Basic operations

	error_check
		do
			error_message.wipe_out
		end

feature {NONE} -- Implementation

	register_default_values
		once
			Default_value_table.extend_from_array (<<
				create {VOLUME_INFO}.make
			>>)
		end
end
