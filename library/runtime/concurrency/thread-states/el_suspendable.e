note
	description: "Suspendable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "4"

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
			mutex.lock; mutex.unlock -- ensures thread is in wait condition before signaling
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
