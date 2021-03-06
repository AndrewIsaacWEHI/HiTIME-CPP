[![travis](https://travis-ci.org/bjpop/HiTIME-CPP.svg?branch=master)](https://travis-ci.org/bjpop/HiTIME-CPP)

# HiTIME-CPP

HiTIME-CPP is a program for identifying twin-ion signals in
[Liquid chromatography-mass spectrometry (LCMS)](https://en.wikipedia.org/wiki/Liquid_chromatography%E2%80%93mass_spectrometry) data. 
HiTIME-CPP is designed to be integrated with existing analysis pipelines, such as those 
created with [OpenMS](https://www.openms.de/). 

HiTIME-CPP filters twin-ion signals in LCMS data. Each data point in the input is scored according to the goodness-of-fit of its neighbourhood to twin Gaussians of expected dimensions and spacings. This process re-weights each data point by its likelihood of being part of a true twin ion signal. 

  * `hitime score`: takes an [mzML](https://en.wikipedia.org/wiki/Mass_spectrometry_data_format#mzML) file as input and produces an mzML file as output. Intentsity values in the input file which correspond to the lower mass in a twin-ion peak are retained and scored highly in the output, all other intensities are downweighted towards zero.

## License

HiTIME is released as open source software under the terms of the [3-Clause BSD License](https://opensource.org/licenses/BSD-3-Clause).
See the contents of the file called LICENSE in the top level of the source
code repository for a copy of the terms.

## Installation

HiTIME-CPP is provided as a Docker container, which can be installed like so (assuming you have docker installed on your computer):

```
docker pull bjpop/hitime
```

Docker can be installed on all modern operating systems. Please review the Docker [installation instructions](https://docs.docker.com/engine/installation/) for more information.

## Building HiTIME-CPP from source 

HiTIME-CPP can be build from source by following the instructions in the `notes` folder:

 * Mac OS X: `notes/build.osx.sh`
 * Linux: `notes/build.linux.sh`

## Builiding HiTIME-CPP using Docker

Run this command in the top-level directory of the source tree:

```
docker build -t bjpop/hitime .
```

## Example docker usage 

We provide a convenient wrapper script to run the HiTIME-CPP docker container.

Test data is included in the `data` folder within the repository. Running the following command
should produce meaningful output saved in `results.mzML`. 

```
./hitime-docker.sh -i data/testing.mzML -o data/results.mzML
```

You might see some warnings in the output which complain about the format the of input `testing.mzML` file. You can
safely ignore them. It is just OpenMS being strict about the format of the file. 

## Usage

```
  -h, --help          Show this help information.
  -a, --iratio arg    Ratio of doublet intensities (isotope / parent).
                      Defaults to 1.000000
  -r, --rtwidth arg   Full width at half maximum for retention time in number
                      of scans. Defaults to 17.000000
  -t, --rtwindow arg  Retention time width boundary in standard deviations.
                      Defaults to 1.500000
  -p, --ppm arg       M/Z tolerance in parts per million. Defaults to
                      4.000000
  -m, --mzwidth arg   M/Z full width at half maximum in parts per million.
                      Defaults to 150.000000
  -z, --mzwindow arg  M/Z window boundary in standard deviations. Defaults to
                      1.500000
  -d, --mzdelta arg   M/Z delta for doublets. Defaults to 6.020100
  -n, --mindata arg   Minimum number of data points required in each sample
                      region. Defaults to 10.828026
      --debug         Generate debugging output
  -j, --threads arg   Number of threads to use. Defaults to 1
  -c, --cache arg     Number of input spectra to retain in cache. Defaults to 50
  -i, --infile arg    Input mzML file
  -o, --outfile arg   Output mzML file

```

For example:

```
hitime -j 4 -i example.mzML -o results.mzML 
```

for a computation using 4 threads, where `example.mzML` contains the input mass spectrometry data in mzML format, and the output file is called `results.mzML`

## Indexing your input mzML file:

```
FileConverter -ini openms.ini -in input.mzML -out data/input_indexed.mzML
```

An example openms.ini can be found in `notes/openms.ini`.

## More test data

Small dataset (1.9 MB)
```
curl -sL https://melbourne.figshare.com/ndownloader/files/14131079 > BSA_SUBSET.mzML
```

Larger dataset (82 MB)

A pure protein that was reduced, reacted with heavy/light paracetamol and then digested. It contains lots of twin ions. Because these twin-ions are mostly peptide derivatives, they come in multiple charge states which effectively gives us a few different doublet spacings. There are many separated by 6.0201, a good number separated by 3.01005 and a few separated by 2.0067. We have removed any points with intensity <1000 to make the file smaller.
```
curl -sL https://melbourne.figshare.com/ndownloader/files/14131085 > BSA_FULL.mzML
```
