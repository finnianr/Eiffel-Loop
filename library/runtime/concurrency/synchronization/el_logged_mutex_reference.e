note
	description: "[
		Guards objects that require thread synchronization and helps to detect deadlock.
		Any time a thread is forced to wait for a lock it is reported to the thread's log.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:49:05 GMT (Sunday 10th May 2015)"
	revision: "2"

class
	EL_LOGGED_MUTEX_REFERENCE [G]

inherit
	EL_MUTEX_REFERENCE [G]
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
			if not try_lock then
				log.put_string ("Waiting to lock ")
				log.put_string (field_name)
				log.put_string ("... ")
				Precursor
				log.put_line ("locked!")
			end
			log.exit_no_trailer
		end

feature -- Element change

	set_field_name (owner_object: ANY; a_field_name: STRING)
			--
		do
			create field_name.make_empty
			field_name.append_character ('{')
			field_name.append (owner_object.generating_type)
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




