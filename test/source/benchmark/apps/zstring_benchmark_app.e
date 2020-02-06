note
	description: "Zstring benchmark app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 13:54:29 GMT (Thursday 6th February 2020)"
	revision: "10"

class
	ZSTRING_BENCHMARK_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name, standard_options
		end

	SHARED_HEXAGRAM_STRINGS

	EL_SHARED_ZCODEC

create
	make

feature {NONE} -- Initialization

	initialize
		do
			log.enter ("initialize")
			inspect Benchmark_option.codec
				when 1 then
					set_system_codec (create {EL_ISO_8859_1_ZCODEC}.make)
				when 15 then
					set_system_codec (create {EL_ISO_8859_15_ZCODEC}.make)
			else
			end
			call (Hexagram)
			create benchmark_html.make_from_file (Output_path #$ [system_codec.id])
			log.exit
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			lio.put_integer_field ("Codec is latin", system_codec.id)
			lio.put_new_line
			lio.put_integer_field ("Runs per test", Benchmark_option.number_of_runs)
			lio.put_new_line
			lio.put_new_line

			add_benchmarks ([
				create {ZSTRING_BENCHMARK}.make (Benchmark_option),
				create {STRING_32_BENCHMARK}.make (Benchmark_option)
			])
			add_benchmarks ([
				create {MIXED_ENCODING_ZSTRING_BENCHMARK}.make (Benchmark_option),
				create {MIXED_ENCODING_STRING_32_BENCHMARK}.make (Benchmark_option)
			])

			benchmark_html.serialize

			log.exit
		end

feature {NONE} -- Implementation

	add_benchmarks (benchmark: like Type_benchmark_table.benchmark)
		do
			benchmark_html.performance_tables.extend (create {PERFORMANCE_BENCHMARK_TABLE}.make (system_codec.id, benchmark))
			benchmark_html.memory_tables.extend (create {MEMORY_BENCHMARK_TABLE}.make (system_codec.id, benchmark))
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ZSTRING_BENCHMARK_APP}, All_routines],
				[{STRING_32_BENCHMARK}, All_routines],
				[{ZSTRING_BENCHMARK}, All_routines],
				[{MIXED_ENCODING_STRING_32_BENCHMARK}, All_routines],
				[{MIXED_ENCODING_ZSTRING_BENCHMARK}, All_routines]
			>>
		end

	standard_options: EL_DEFAULT_COMMAND_OPTION_LIST
		do
			Result := Precursor + Benchmark_option
		end

feature {NONE} -- Internal attributes

	benchmark_html: BENCHMARK_HTML

feature {NONE} -- Type definition

	Type_benchmark_table: BENCHMARK_TABLE
		require
			never_called: False
		once
		end

feature {NONE} -- Constants

	Benchmark_option: ZSTRING_BENCHMARK_COMMAND_OPTIONS
		once
			create Result.make
		end

	Description: STRING = "Benchmark ZSTRING in relation to STRING_32"

	Option_name: STRING = "zstring_benchmark"

	Output_path: ZSTRING
		once
			Result := "workarea/ZSTRING-benchmarks-latin-%S.html"
		end

end
