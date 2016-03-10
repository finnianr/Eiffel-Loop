These classes implement a radix-2, decimation in time, Fast Fourrier Transform.

The class WINDOWER_DOUBLE is a deferred class for the windowing function to be used in the FFT. A rectangular window (RECTANGULAR_WINDOWER_DOUBLE) and a Hamming window (DEFAULT_WINDOWER_DOUBLE) are provided. There are many other windows possible.

The class FFT_COMPLEX_DOUBLE computes the Fast Fourier Transform and holds the input data for the FFT and the output data computed from the FFT. 

The VECTOR_COMPLEX_DOUBLE class is used from the matrix cluster to hold input and output data.

Greg Lee
October 2005
