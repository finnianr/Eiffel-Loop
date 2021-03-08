note
	description: "Object is a solitary globally shared instance, i.e. a singleton"
	notes: "[
		Use one of the following classes in a once routine to retrieve this object from `Singleton_table'
			
		* [$source EL_SINGLETON]
		* [$source EL_CONFORMING_SINGLETON]

		For example:

			feature {NONE} -- Constants

				Database: RBOX_DATABASE
					once
						Result := create {EL_CONFORMING_SINGLETON [RBOX_DATABASE]}
					end

		In this example the routine will return either [$source RBOX_DATABASE] or [$source RBOX_TEST_DATABASE]
		depending on which instance is found in `Singleton_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-08 11:01:28 GMT (Monday 8th March 2021)"
	revision: "2"

deferred class
	EL_SOLITARY

inherit
	EL_SHARED_SINGLETONS

feature {NONE} -- Initialization

	make
		do
			put_singleton (Current)
		ensure
			globally_shareable: Singleton_table.has (Current)
		end

end