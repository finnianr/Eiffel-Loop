note
	description: "[
		Guards objects that require thread synchronization and helps to detect deadlock.
		Any time a thread is forced to wait for a lock it is reported to the thread's log.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SYNCHRONIZED_REF [G]

inherit
	EL_STD_SYNCHRONIZED_REF [G]
		redefine
			lock, make
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (an_item: like item)
			--
		do
			Precursor (an_item)
			field_name := Default_field_name
		end

feature -- Basic

	lock
			--
		do
			log.enter_no_header ("lock")
			if not monitor.try_lock then
				log.put_string ("Waiting to lock ")
				log.put_string (field_name)
				log.put_string ("... ")
				monitor.lock
				log.put_line ("locked!")
			end
			owner_id := current_thread_id
			log.exit_no_trailer
		end

feature -- Element change

	set_field_name (owner: ANY; a_field_name: STRING)
			--
		do
			create field_name.make_empty
			field_name.append_character ('{')
			field_name.append (owner.generating_type)
			field_name.append ("}.")
			field_name.append (a_field_name)
		end

feature {NONE} -- Implementation

	field_name: STRING

feature {NONE} -- Constants

	Default_field_name: STRING
			--
		once ("PROCESS")
			Result := "a field"
		end

end




