 ___  ___    _    ___   __  __  ___ 
| _ \| __|  /_\  |   \ |  \/  || __|
|   /| _|  / _ \ | |) || |\/| || _|   RDG x RiverLy README File Template
|_|_\|___|/_/ \_\|___/ |_|  |_||___|  English - Version: 1 (2025-12-15)

This README file was generated on 2025-12-15 by Jérôme Le Coz.
Last updated: 2025-12-17.


# GENERAL INFORMATION __________________________________________________________
Dataset title: Suspended sand measurements in the Isere River catchment for sampler comparison
 
DOI: https://doi.org/10.57745/5EBITB

Citation:

Contact email: guillaume.dramais@inrae.fr

Related publication:
Marggraf, Jessica (in prep.), Evaluation of Delft Bottle and Pump
Point-samplers for Characterizing Sand Suspension in Rivers, Water Resources
Research. 

<Remove or add any section if applicable>


# METHODOLOGICAL INFORMATION ___________________________________________________
## Environmental/experimental condition ________________________________________
Suspended-sand measurements at three sampling sites in the Isere River catchment
using US P-6, Delft bottle and pump PP36 as well as flume experiments using the
pump PP36 and digitized data from the literature (Dijkman & Milisic (1982) and
Beverage & Williams (1989).

## Description of sources and methods used to collect and generate data ________
This dataset is composed of suspended sand concentration and grain size data
used for the evaluation of suspended sediment samplers. The data were collected
at three different study sites in the French Isère River catchment. One site is
located in the Isère River at Grenoble Campus, the second site in the Arc River
at Chamousset and another one in the Romanche River at Pont Rouge. Several
specific suspended sand and sediment samplers were used: the US P-6, the Delft
bottle and the novel pump PP36. Field sites, samplers and measurement protocols
are described in detail in the article. Sand concentration of liquid samples
taken using the US P-6 were determined by filtration after separating the fine
sediment fraction (< 63 µm). Filters were dried at 104°C and weighed to
determine the dry sand mass. Solid sediment samples obtained by the other two
samplers were sieved at 63 µm in the field. In the laboratory, large organic
particles were removed manually, the samples were dried at 104°C for 12 hours
and weighed. Sand fluxes determined by the Delft bottle were converted using
velocity measurements with Acoustic Doppler Current Profiler or measurement
reels to point sand concentrations.

## Methods for processing the data _____________________________________________
<***If applicable, describe how submitted data were processed and include
details that may be important for data reuse or replication. Add comments
to explain each step taken. For example, include data cleaning and analysis
methods; code and/or algorithms, de-identification procedures for sensitive
data human subjects or endangered species data.***>
 
## Quality-assurance procedures performed on the data __________________________

## Other contextual information ________________________________________________
<***Any information that you consider important for the evaluation of the
dataset’s quality and reuse thereof: for example, information about the software
required to interpret the data. If applicable and not covered above, include
full name and version of software, and any necessary packages or libraries
needed to read and interpret the data, *e.g.* to run scripts.***>
 
 
# DATA & FILE OVERVIEW _________________________________________________________
## File hierarchy convention ___________________________________________________
.
├── data-additional_Beverage-and-Williams-1989_sand-flux_125-250-micrometre_Colorado-Mississippi.csv
├── data-additional_Beverage-and-Williams-1989_sand-flux_62-125-micrometre_Colorado-Mississippi.csv
├── data-additional_Beverage-and-Williams-1989_sand-flux_62-larger-micrometre_Colorado-Mississippi.csv
├── data-additional_Dijkman-and-Milisic-1982.csv
├── data-additional_Florian-Benoit-2025.csv
├── data-additional_Samuel-Payen_field.csv
├── data-additional_Samuel-Payen_lab.csv
├── data-comparison_pump-PP36_vs_DB_point_Grenoble-Campus.csv
├── data-comparison_pump-PP36_vs_US-P-6_cross-section_Grenoble-Campus.csv
├── data-comparison_pump-PP36_vs_US-P-6_grain-size-distribution_all-sites.csv
├── data-comparison_pump-PP36_vs_US-P-6_point_all-sites.csv
├── data-gaugings_DB_localisation.csv
├── data-gaugings_US-P-6_localisation.csv
└── meta_cross-section-area_Grenoble-Campus.csv
1 directory, 14 files

## File naming convention ______________________________________________________
### data-additional:
No naming convention

### data-comparison:
data-comparison_{1}_vs_{2}_{3}_{4}.csv
{1} first sampler type:
  -- pump-PP36
{2} second sampler type:
  -- DB (Delft bottle) 
  -- US-P-6
{3} measurement type:
  -- point (point sand concentration)
  -- cross-section (cross-sectional averages of sand concentration)
  -- grain-size-distribution (point grain size distribution)
{4} localisation:
  -- all-sites
  -- Grenoble-Campus (Isère River at Grenoble Campus)
  -- Chamousset (Arc River at Chamousset)
  -- Pont-Rouge (Romanche River at Pont Rouge)


## Additional information ______________________________________________________
Also included are datasets from four other studies in seven files. First,
there are the datasets produced during two internships at the Compagnie National
du Rhone (CNR), by Florian Benoit et Samuel Payen. Their data is included in the
main part of the article and has not been published elsewhere. Data by SPayen is
split into the measurements obtained in the laboratory and those in the field.
Second, there are the datasets from sampler comparison studies performed by
Dijkman and Milisic (1982) and Beverage and Williams (1989). The data from
Dijkman and Milisic (1982) was digitized from an appendix of their report and is
included here for completeness and to provide the data in a reusable form. Data
from Beverage and Williams (1989) was digitized from their figures in their
article using WebPlotDigitizer (https://apps.automeris.io/wpd4/), which may
introduce errors. However, as this data is used for comparison purposes only, we
assume the error is negligible. The data is split into three files, each for
another grain size class, 62 – 125 μm, 125 – 250 μm and all sand sized-particles
larger than 62 μm.


<***Repeat the following section for each folder or file, as appropriate.
Recurring items may also be explained in a common initial section.***>

# DATA-SPECIFIC INFORMATION ____________________________________________________
## Filename ____________________________________________________________________
Path:

Filename:

Description:

Column information:
- displayed name : 
  long_name: <full “human readable” name>
  description:
  type: <e.g. numeric, date, charactere>
  unit: 
  allowed_values: <list of possible values>

Missing data codes:

Additional information:





- data_comparison_DB_gaugings: includes cross-sectional averages of sand concentration, flux, grain size and uncertainties for samplings with the Delft bottle; used for IDs 1 and 3

- data_comparison_P6_gaugings.csv: includes cross-sectional averages of sand and fine-sediment concentration, flux, grain size and uncertainties for samplings with the US P-6; used for IDs 1 and 3

- data_comparison_pump_P6_point.csv: includes point sand concentrations collected simultaneously with the US P-6 and the pump PP36 at all three sites, used for ID 5

- data_comparison_pump_P6_XS.csv: includes cross-sectional averages of sand concentration and flux collected with the US P-6 and the pump PP36 in the Isère River at Grenoble Campus; used for ID 2

- data_comparison_pump_P6_GSD.csv: includes point sand grain size collected with the US P-6 and the pump PP36 at all three sites; used for ID 4

- data_comparison_DB_pump_point: includes point sand concentration and flux collected with the Delft bottle and the pump PP36 in the Isère River at Grenoble Campus; used for ID 6

- meta_area-cross-section_Grenoble-Campus_XS.csv: includes cell sizes and number of cells of ADCP measurements for samplings in the Isère River at Grenoble Campus, used for the conversion of total fluxes through the cross-section to fluxes in kg/m2/s to compare with literature data in the discussion

