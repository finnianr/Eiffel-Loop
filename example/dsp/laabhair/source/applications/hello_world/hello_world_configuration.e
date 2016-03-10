indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	HELLO_WORLD_CONFIGURATION

inherit
	LB_BASIC_APP_CONFIGURATION
		redefine
			read_command_line_args, create_editable_fields
		end
		
creation
	make

feature {NONE} -- Initialization

	read_command_line_args is
			--
		do
			Precursor
			set_argument (
				"start", counter_start,
				"Initial counter value: $VALUE%N   (Change with: -start <value>)"
			)
		end

	create_editable_fields is
			--
		do
			Precursor
			create counter_start.make (
				Current, Default_counter_start
			)
			add_field (counter_start)
		end

feature -- Access

	counter_start: EL_EDITABLE_INTEGER

feature -- Default values

	Default_sample_interval_millisecs: INTEGER is 100

	Default_signal_threshold: REAL is 0.005
	
	Default_counter_start: INTEGER is 1000

end


