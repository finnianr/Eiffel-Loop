note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-02 16:59:00 GMT (Monday 2nd October 2017)"
	revision: "2"

deferred class
	EL_SUSPENDABLE

feature {NONE} -- Initialization

	make_default
			--
		do
			create can_resume.make
			create mutex.make
		end

feature -- Basic operations

	resume
			-- unblock thread
		do
			can_resume.signal
		end

	suspend
			-- block thread and wait for signal to resume
		do
			mutex.lock
				internal_is_suspended := True
				on_suspension
			can_resume.wait (mutex)
				internal_is_suspended := False
			mutex.unlock
		end

feature -- Status query

	is_suspended: BOOLEAN
			--
		do
			mutex.lock
				Result := internal_is_suspended
			mutex.unlock
		end

feature {NONE} -- Event handling

	on_suspension
			--
		do
		end

feature {NONE} -- Implementation

	internal_is_suspended: BOOLEAN

	can_resume: CONDITION_VARIABLE

	mutex: MUTEX

end
