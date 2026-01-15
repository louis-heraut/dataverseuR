 ___  ___    _    ___   __  __  ___ 
| _ \| __|  /_\  |   \ |  \/  || __|
|   /| _|  / _ \ | |) || |\/| || _|   RDG x RiverLy README File Template
|_|_\|___|/_/ \_\|___/ |_|  |_||___|  English - Version: 1 (2025-12-15)

This README file was automatically generated on 2026-01-05 by Louis Héraut.
Last update: 2026-01-11.


# GENERAL INFORMATION __________________________________________________________
Dataset title: >
  Suspended sand measurements in the Isere River catchment for sampler
  comparison

DOI: https://doi.org/10.57745/5EBITB

Citation: >
  Marggraf, Jessica; Camenen, Benoît; Le Coz, Jérôme; Payen, Samuel; Benoît,
  Florian; Dramais, Guillaume; Lauters, François; Pierrefeu, Gilles, 2026,
  "Suspended sand measurements in the Isere River catchment for sampler
  comparison", https://doi.org/10.57745/5EBITB, Recherche Data Gouv

Contact email: guillaume.dramais@inrae.fr

Related publication: >
  Marggraf, Jessica (in prep.), Evaluation of Delft Bottle and Pump
  Point-samplers for Characterizing Sand Suspension in Rivers, Water Resources
  Research.


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


# DATA & FILE OVERVIEW _________________________________________________________
## File hierarchy convention ___________________________________________________
.
├── data-comparison_pump-PP36_vs_DB_point_Grenoble-Campus.csv
├── data-comparison_pump-PP36_vs_US-P-6_cross-section_Grenoble-Campus.csv
├── data-comparison_pump-PP36_vs_US-P-6_grain-size-distribution_all-sites.csv
├── data-comparison_pump-PP36_vs_US-P-6_point_all-sites.csv
├── data-gaugings_DB_Grenoble-Campus.csv
├── data-gaugings_US-P-6_Grenoble-Campus.csv
├── data-literature_Benoit-2025_lab.csv
├── data-literature_Beverage-and-Williams-1989_sand-flux_125-250-micrometre_Colorado-Mississippi.csv
├── data-literature_Beverage-and-Williams-1989_sand-flux_62-125-micrometre_Colorado-Mississippi.csv
├── data-literature_Beverage-and-Williams-1989_sand-flux_62-larger-micrometre_Colorado-Mississippi.csv
├── data-literature_Dijkman-and-Milisic-1982.csv
├── data-literature_Payen-2024_field.csv
├── data-literature_Payen-2024_lab.csv
├── meta_cross-section-area_Grenoble-Campus.csv
└── README.txt
0 directoryies, 15 files

## File naming convention ______________________________________________________
### data-literature:
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


# DATA-SPECIFIC INFORMATION ____________________________________________________
## File 1 ______________________________________________________________________
Filename: data-comparison_pump-PP36_vs_DB_point_Grenoble-Campus.csv

Path: .

Description: >
  Includes point sand concentration and flux collected with the Delft bottle and
  the pump PP36 in the Isère River at Grenoble Campus; used for ID 6.

Column information:

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: Abscissa
  long_name: Distance from left bank
  description: >
    Horizontal distance of the sample location from the left bank (corresponding
    to x) 
  type: integer
  unit: m

- displayed_name: Height_field
  long_name: Sampling height above the river bed
  description: >
    Sampling height above the river bed measured in the field using the length
    information on the cableway (corresponding to y)
  type: numeric
  unit: m

- displayed_name: Depth_field
  long_name: Depth below the surface
  description: >
    Sampling depth below the surface to the river measured in the field
    (corresponding to y)
  type: numeric
  unit: m

- displayed_name: Sand_flux_DB_kg_s_m2
  long_name: Sand flux measured using the Delft bottle
  description: >
    Sand flux measured using the Delft bottle, calculated with the
    corresponding correction factor alpha based on the flow velocity at the
    sampling point and the median grain size
  type: numeric
  unit: kg/m2s

- displayed_name: Velocity_sampling_point_ADCP
  long_name: Flow velocity at the sampling point
  description: >
    Flow velocity at the sampling point determined using stationary ADCP
    profiles
  type: numeric
  unit: m/s

- displayed_name: Sand_concentration_DB_ADCP
  long_name: Sand concentration using the Delft bottle converted with ADCP
  description: >
    Suspended sand concentration using the Delft bottle converted with the
    ADCP-based velocity at the sampling point from sand flux
  type: numeric
  unit: g/l

- displayed_name: Sand_concentration_DB_reel
  long_name: >
    Sand concentration using the Delft bottle converted with measurement reel
  description: >
    Suspended sand concentration using the Delft bottle converted with the
    velocity reel-based velocity at the sampling point from sand flux
  type: numeric
  unit: g/l

- displayed_name: Sand_concentration_pump_PP36
  long_name: Sand concentration pump PP36
  description: Suspended sand concentration determined using the pump PP36
  type: numeric
  unit: g/l

Missing data codes: NA

## File 2 ______________________________________________________________________
Filename: data-comparison_pump-PP36_vs_US-P-6_cross-section_Grenoble-Campus.csv

Path: .

Description: >
  Includes cross-sectional averages of sand concentration and flux collected
  with the US P-6 and the pump PP36 in the Isère River at Grenoble Campus; used
  for ID 2. They were determined by integrating point sand concentrations
  through the cross-section using ADCP-based velocities and physical basis as
  described in Marggraf et al. (2024).

Column information:

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: Flux_t_h_US_P6
  long_name: Total sand flux determined using the US P-6
  description: Total sand flux in the cross-section determined using the US P-6
  type: numeric
  unit: t/h

- displayed_name: Flux_t_h_pump_PP36
  long_name: Total sand flux determined using the pump PP36
  description: >
    Total sand flux in the cross-section determined using the pump PP36
  type: numeric
  unit: t/h

- displayed_name: Sand_concentration_US_P6
  long_name: Mean cross-sectional sand concentration determined using the US P-6
  description: >
    Mean cross-sectional sand concentration determined using the US P-6
  type: numeric
  unit: g/l

- displayed_name: Sand_concentration_pump_PP36
  long_name: >
    Mean cross-sectional sand concentration determined using the pump PP36
  description: >
    Mean cross-sectional sand concentration determined using the pump PP36
  type: numeric
  unit: g/l

- displayed_name: Q_sampling_m3_s
  long_name: Discharge during the sampling
  description: >
    Mean discharge during the duration of the sampling campaign, measured by the
    hydrometric station
  type: numeric
  unit: m3/s

Missing data codes: NA

## File 3 ______________________________________________________________________
Filename: data-comparison_pump-PP36_vs_US-P-6_grain-size-distribution_all-sites.csv

Path: .

Description: >
  Includes point sand grain size collected with the US P-6 and the pump PP36 at
  all three sites; used for ID 4.

Column information:

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: D10_US_P6
  long_name: D10 grain size of sample collected using the US P-6
  description:
  type: integer
  unit: micrometres

- displayed_name: D10_pump_PP36
  long_name: D10 grain size of sample collected using the pump PP36
  description:
  type: numeric
  unit: micrometres

- displayed_name: D50_US_P6
  long_name: D50 grain size of sample collected using the US P-6
  description:
  type: integer
  unit: micrometres

- displayed_name: D50_pump_PP36
  long_name: D50 grain size of sample collected using the pump PP36
  description:
  type: numeric
  unit: micrometres

- displayed_name: D90_US_P6
  long_name: D90 grain size of sample collected using the US P-6
  description:
  type: integer
  unit: micrometres

- displayed_name: D90_pump_PP36
  long_name: D90 grain size of sample collected using the pump PP36
  description:
  type: numeric
  unit: micrometres

Missing data codes: NA

## File 4 ______________________________________________________________________
Filename: data-comparison_pump-PP36_vs_US-P-6_point_all-sites.csv

Path: .

Description: >
 Includes point sand concentrations collected simultaneously with the US P-6
 and the pump PP36 at all three sites, used for ID 5.

Column information:

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: Sand_concentration_US_P6
  long_name: Sand concentration determined using the US P-6
  description: Point suspended sand concentration determined using the US P-6
  type: numeric
  unit: g/l

- displayed_name: Sand_concentration_pump_PP36
  long_name: Sand concentration determined using the pump PP36
  description: Sand concentration determined using the pump PP36
  type: numeric
  unit: g/l

Missing data codes: NA

## File 5 ______________________________________________________________________
Filename: data-gaugings_DB_Grenoble-Campus.csv

Path: .

Description: >
  Includes cross-sectional averages of sand concentration, flux, grain size and
  uncertainties for samplings with the Delft bottle; used for IDs 1 and 3.

Column information:

- displayed_name: Comp
  long_name: Dummy variable to relate simultaneous measurements
  description: >
    On several occasions, two gaugings were performed using the US P-6, whereas
    only one was performed using the Delft bottle during the same time. To
    facilitate data processing, the measurements and results were doubled in
    these cases and receive the same number for "comp" to plot and compare with
    the two simultaneous US P-6 gaugings.
  type: integer

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: Q_sampling_m3_s
  long_name: Discharge during the sampling
  description: >
    Mean discharge during the duration of the sampling campaign, measured by the
    hydrometric station
  type: numeric
  unit: m3/s

- displayed_name: Stage_sampling_m
  long_name: Stage during the sampling
  description: >
    Mean water stage during the duration of the sampling campaign, measured by
    the hydrometric station
  type: numeric
  unit: m

- displayed_name: spm_sampling_g_l
  long_name: Suspended sediment concentration
  description: >
    Mean total suspended sediment load (including sand, silt and clay) during
    the duration of the sampling campaign, measured by the hydrometric station
  type: numeric
  unit: g/l

- displayed_name: Sand_concentration_g_l
  long_name: Mean cross-sectional suspended sand concentration
  description: >
    Mean cross-sectional suspended sand concentration determined using the Delft
    bottle and interpolated following Marggraf et al., (2024)
  type: numeric
  unit: g/l

- displayed_name: Sand_flux_kg_s
  long_name: Total sand flux through the cross-section
  description: >
    Total sand flux through the cross-section determined using the Delft bottle
    and interpolated following Marggraf et al., (2024)
  type: numeric
  unit: kg/s

- displayed_name: No_samples_used_for_ISO_gsd
  long_name: >
    Number of samples with grain size measurements used for the interpolation in
    the cross-section
  description: >
    Number of samples with grain size measurements used for the interpolation in
    the cross-section following ISO to obtain a mean cross-sectional grain size
    distribution
  type: integer

- displayed_name: D10_mum
  long_name: Mean cross-sectional D10
  description: >
    D10 of the mean cross-sectional grain size distribution following ISO
  type: numeric
  unit: micrometres

- displayed_name: D50_mum
  long_name: Mean cross-sectional D50
  description: >
    D50 of the mean cross-sectional grain size distribution following ISO
  type: numeric
  unit: micrometres

- displayed_name: D90_mum
  long_name: Mean cross-sectional D90
  description: >
    D90 of the mean cross-sectional grain size distribution following ISO
  type: numeric
  unit: micrometres

- displayed_name: U_C
  long_name: Uncertainty in mean cross-sectional suspended sand concentration
  description: Calculated following Marggraf et al. (2024)
  type: numeric
  unit: %

- displayed_name: U_Q
  long_name: Uncertainty in total discharge 
  description: calculated using QRevInt
  type: numeric
  unit: %

- displayed_name: U_F
  long_name: Uncertainty in total suspended sand flux through the cross-section
  description: Calculated following Marggraf et al. (2024)
  type: numeric
  unit: %

- displayed_name: sigma_mum
  long_name: Width of the mean cross-sectional grain size distribution
  description: Calculated as the grain size indices using ISO
  type: numeric
  unit: micrometres

Missing data codes: NA

## File 6 ______________________________________________________________________
Filename: data-gaugings_US-P-6_Grenoble-Campus.csv

Path: .

Description: >
  Includes cross-sectional averages of sand and fine-sediment concentration,
  flux, grain size and uncertainties for samplings with the US P-6; used for
  comparison IDs 1 and 3.

Column information:

- displayed_name: Comp
  long_name: >
    Dummy variable to relate simultaneous measurements with Delft bottle
    measurements
  description: >
    On several occasions, two gaugings were performed using the US P-6, whereas
    only one was performed using the Delft bottle during the same time. To
    facilitate data processing, the US P-6 measurements related to the same
    Delft bottle measurement obtained the same "comp" value.
  type: integer

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: Q_sampling_m3_s
  long_name: Discharge during the sampling
  description: >
    Mean discharge during the duration of the sampling campaign, measured by the
    hydrometric station
  type: numeric
  unit: m3/s

- displayed_name: Stage_sampling_m
  long_name: Stage during the sampling
  description: >
    Mean water stage during the duration of the sampling campaign, measured by
    the hydrometric station
  type: numeric
  unit: m

- displayed_name: spm_sampling_g_l
  long_name: Suspended sediment concentration
  description: >
    Mean total suspended sediment load (including sand, silt and clay) during
    the duration of the sampling campaign, measured by the hydrometric station
  type: numeric
  unit: g/l

- displayed_name: Sand_concentration_g_l
  long_name: Mean cross-sectional suspended sand concentration
  description: >
    Mean cross-sectional suspended sand concentration determined using the
    US P-6 and interpolated following Marggraf et al., (2024)
  type: numeric
  unit: g/l

- displayed_name: Sand_flux_kg_s
  long_name: Total sand flux through the cross-section
  description: >
    Total sand flux through the cross-section determined using the US P-6 and
    interpolated following Marggraf et al., (2024)
  type: numeric
  unit: kg/s

- displayed_name: No_samples_used_for_ISO_gsd
  long_name: >
    Number of samples with grain size measurements used for the interpolation
    in the cross-section
  description: >
    Number of samples with grain size measurements used for the interpolation in
    the cross-section following ISO to obtain a mean cross-sectional grain size
    distribution
  type: integer

- displayed_name: D10_mum
  long_name: Mean cross-sectional D10
  description: >
    D10 of the mean cross-sectional grain size distribution following ISO
  type: numeric
  unit: micrometres

- displayed_name: D50_mum
  long_name: Mean cross-sectional D50
  description: >
    D50 of the mean cross-sectional grain size distribution following ISO
  type: numeric
  unit: micrometres

- displayed_name: D90_mum
  long_name: Mean cross-sectional D90
  description: >
    D90 of the mean cross-sectional grain size distribution following ISO
  type: numeric
  unit: micrometres

- displayed_name: Fine_concentration_g_l
  long_name: Mean cross-sectional suspended fine concentration
  description: >
    Mean cross-sectional suspended fine concentration (clay and silt) determined
    using the US P-6
  type: numeric
  unit: g/l

- displayed_name: Fine_flux_kg_s
  long_name: Fine sediment flux
  description: >
    Total suspended fine (silt and clay) sediment flux through the cross-section
  type: numeric
  unit: kg/s

- displayed_name: U_C
  long_name: Uncertainty in mean cross-sectional suspended sand concentration
  description: Calculated following Marggraf et al. (2024)
  type: numeric
  unit: %

- displayed_name: U_Q
  long_name: Uncertainty in total discharge 
  description: calculated using QRevInt
  type: numeric
  unit: %

- displayed_name: U_F
  long_name: Uncertainty in total suspended sand flux through the cross-section
  description: Calculated following Marggraf et al. (2024)
  type: numeric
  unit: %

- displayed_name: sigma_mum
  long_name: Width of the mean cross-sectional grain size distribution
  description: Calculated as the grain size indices using ISO
  type: numeric
  unit: micrometres

- displayed_name: S
  long_name: Ratio between fine and sand concentration
  description:
  type: numeric

Missing data codes: NA

## File 7 ______________________________________________________________________
Filename: data-literature_Benoit-2025_lab.csv

Path: .

Description: >
  Data from flume experiments conducted during the MSc thesis by F. Benoit in
  2023 at the Compagnie National du Rhone, France. 

Column information:

- displayed_name: Type
  long_name: Nozzle type and diameter
  description: >
    Nozzle type and diameter used for the pump sampler exposed in the center of
    the flume. Different nozzle diameters (6, 10 and 14 mm), types (standard
    nozzle or suction stainer) and nozzle orientations (perpendicular or
    parallel to the main flow direction) were deployed.
  type: character
  allowed_values:
    - Nozzle parallel
    - Nozzle perpendicular
    - Stainer parallel
    - Stainer perpendicular

- displayed_name: Diameter_nozzle_mm
  long_name: Nozzle diameter 
  description: Diameter of the water entry into the nozzle
  type: integer
  unit: mm

- displayed_name: Orientation
  long_name: Orientation of the nozzle
  description: >
    Orientation of the nozzle relative to the main flow in the flume channel
  type: character
  allowed_values:
    - parallel
    - perpendicular

- displayed_name: Sampling_velocity_m_s
  long_name: Sampling velocity
  description: The sampling velocity corresponds to the pumping velocity.
  type: numeric
  unit: m/s

- displayed_name: Ratio_velocity
  long_name: Velocity ratio between sampling velocity and flow velocity
  description: >
    Velocity ratio between sampling velocity and mean flow velocity (1.25 m/s)
  type: numeric

- displayed_name: C_reference_g_l
  long_name: Reference sand concentration
  description: >
    The reference sand concentration is measured at the outlet of the flume and
    is considered representative of the sampling location in the flume.
  type: numeric
  unit: g/l

- displayed_name: C_sampler_g_l
  long_name: Sand concentration measured by the pump sampler
  description: >
    Sand concentration measured by the pump sampler using the specified nozzle
  type: numeric
  unit: g/l

- displayed_name: Ratio_Conc
  long_name: >
    Sand concentration ratio between the concentration collected by the sampler
    and the reference concentration
  description: >
    Sand concentration ratio between the concentration collected by the sampler
    and the reference concentration
  type: numeric

- displayed_name: Velocity_flow_m_s
  long_name: Mean flow velocity
  description: Mean flow velocity in the flume
  type: numeric
  unit: m/s

Missing data codes: NA

## File 8 ______________________________________________________________________
Filename: data-literature_Beverage-and-Williams-1989_sand-flux_125-250-micrometre_Colorado-Mississippi.csv

Path: .

Description: >
  Data digitized from Beverage and Williams (1989) containing sand flux data in
  the size class 125 - 250 micrometres collected in the Colorado and Mississippi
  using the US P-61 and Delft bottle samplers.

Column information:

- displayed_name: Sand_flux_P61_g_m2s
  long_name: Sand flux collected using the US P-61 (125 - 250 micrometres)
  description: Sand flux collected using the US P-61 (125 - 250 micrometres)
  type: numeric
  unit: g/m2s

- displayed_name: Sand_flux_DB_g_m2s
  long_name: Sand flux collected using the Delft bottle (125 - 250 micrometres)
  description: >
    Sand flux collected using the Delft bottle (125 - 250 micrometres)
  type: numeric
  unit: g/m2s

Missing data codes: NA

## File 9 ______________________________________________________________________
Filename: data-literature_Beverage-and-Williams-1989_sand-flux_62-125-micrometre_Colorado-Mississippi.csv

Path: .

Description: >
  Data digitized from Beverage and Williams (1989) containing sand flux data in
  the size class 62 - 125 micrometres collected in the Colorado and Mississippi
  using the US P-61 and Delft bottle samplers.

Column information:

- displayed_name: Sand_flux_P61_g_m2s
  long_name: Sand flux collected using the US P-61 (62 - 125 micrometres)
  description: Sand flux collected using the US P-61 (62 - 125 micrometres)
  type: numeric
  unit: g/m2s

- displayed_name: Sand_flux_DB_g_m2s
  long_name: Sand flux collected using the Delft bottle (62 - 125 micrometres)
  description: Sand flux collected using the Delft bottle (62 - 125 micrometres)
  type: numeric
  unit: g/m2s

Missing data codes: NA

## File 10 _____________________________________________________________________
Filename: data-literature_Beverage-and-Williams-1989_sand-flux_62-larger-micrometre_Colorado-Mississippi.csv

Path: .

Description: Data digitized from Beverage and Williams (1989) contains all 
sand particles larger than 62 micrometres (doubled with the other size classes). 

Column information:

- displayed_name: Sand_flux_P61_g_m2s
  long_name: Sand flux collected using the US P-61
  description: Sand flux collected using the US P-61
  type: numeric
  unit: g/m2s

- displayed_name: Sand_flux_DB_g_m2s
  long_name: Sand flux collected using the Delft bottle 
  description: Sand flux collected using the Delft bottle 
  type: numeric
  unit: g/m2s

Missing data codes: NA

## File 11 _____________________________________________________________________
Filename: data-literature_Dijkman-and-Milisic-1982.csv

Path: .

Description: >
  This file contains data from Dijkman and Milisic (1982), where they
  investigated suspended sediment samplers based on measurements in the Danube
  River in May 1979. They evaluated a total of five different samplers. As only
  the US P-61 and Delft bottle are of interest for the related article by
  Marggraf et al., only these measurements are contained in this file. They
  measured four grain size fractions based on their settling velocity, only the
  three sand size classes were digitized and included in this article. The Delft
  bottle was deployed using all four available nozzle types, small straight, big
  straight, small bended and big bended nozzle.

Column information:

- displayed_name: Period
  long_name: Measurement number
  description: >
    Multiple measurements were collected one after another during a specific
    measurement duration, each measurement has a new period number and
    indicates the mean transport during the measurement period. For each grain
    size fraction, the period number starts at 1 again.
  type: integer

- displayed_name: Fraction
  long_name: Settling velocity class
  description: >
    Classification of the particles in grain size fractions (72 - 145,
    145 - 230, >230 micrometres) based on their settling velocity (3 - 10,
    10 - 20, >20 mm/s).
  type: character
  allowed_values:
    - 3_10
    - 10_20
    - larger20

- displayed_name: USP
  long_name: sand transport measured using the US P-61
  description: >
    Mean sand transport measured using the US P-61 during a given period
  type: numeric
  unit: kg/m2s

- displayed_name: DBS1
  long_name: >
    Sand transport measured using the Delft bottle with the small, straight
    nozzle
  description:
  type: numeric
  unit: kg/m2s

- displayed_name: DBB1
  long_name: >
    Sand transport measured using the Delft bottle with the big, straight nozzle
  description:
  type: numeric
  unit: kg/m2s

- displayed_name: DBS2
  long_name: >
    Sand transport measured using the Delft bottle with the big, straight nozzle
  description:
  type: numeric
  unit: kg/m2s

- displayed_name: DBB2
  long_name: >
    Sand transport measured using the Delft bottle with the big, bended nozzle
  description:
  type: numeric
  unit: kg/m2s

Missing data codes: NA

## File 12 _____________________________________________________________________
Filename: data-literature_Payen-2024_field.csv

Path: .

Description: >
  Data collected during the MSc thesis by S. Payen at the Compagnie National du
  Rhone, France in 2024 in the Isere River catchment. The samples were collected
  using a pump PP36.

Column information:

- displayed_name: Site
  long_name: Sampling site
  description: >
    Sampling site in the Isere River catchment: Isere River at Grenoble Campus
    (I_GC), Arc River at Chamousset (A_C), Romanche River at Pont Rouge (R)
  type: character
  allowed_values:
    - I_GC
    - A_C
    - R

- displayed_name: Serie
  long_name: Measurement series
  description: >
    At both I_GC and A_C, only one measurement serie has been performed, whereas
    three series with breaks in between were performed in the Romanche River
    (R).
  type: character
  allowed_values:
    - I_GC
    - A_C
    - R1
    - R2
    - R3

- displayed_name: Ratio_velocity_nozzle
  long_name: Velocity ratio between sampling velocity and flow velocity
  description: >
    Velocity ratio between sampling velocity using the standard nozzleand mean
    flow velocity measured using a velocity measurement reel
  type: numeric

- displayed_name: Velocity_sampling_m_s_nozzle
  long_name: Sampling velocity in measurements using the standard nozzle
  description: >
    Sampling velocity i.e. pumping velocity in measurements using the standard
    nozzle
  type: numeric
  unit: m/s

- displayed_name: Sampling_duration_s_nozzle
  long_name: Sampling duration
  description: Sampling duration in measurements using the standard nozzle
  type: numeric
  unit: s

- displayed_name: Csand_sampling_inf400_nozzle
  long_name: >
    Sand concentration smaller than 400 micrometres using the standard nozzle
  description: >
    Suspended sand concentration of particles smaller than 400 micrometres in
    measurements using the standard nozzle
  type: numeric
  unit: g/l

- displayed_name: Csand_sampling_sup400_nozzle
  long_name: >
    Sand concentration larger than 400 micrometres using the standard nozzle
  description: >
    Suspended sand concentration of particles larger than 400 micrometres in
    measurements using the standard nozzle
  type: numeric
  unit: g/l

- displayed_name: Ratio_velocity_stainer
  long_name: <full “human readable” name>
  description:
  type: numeric

- displayed_name: Velocity_sampling_m_s_stainer
  long_name: Sampling velocity in measurements using the stainer
  description: >
    Sampling velocity i.e. pumping velocity in measurements using the stainer
  type: numeric
  unit: m/s

- displayed_name: Sampling_duration_s_stainer
  long_name: Sampling duration
  description: Sampling duration in measurements using the stainer
  type: numeric
  unit: s

- displayed_name: Csand_sampling_inf400_stainer
  long_name: Sand concentration smaller than 400 micrometres using the stainer
  description: >
    Suspended sand concentration of particles smaller than 400 micrometres in
    measurements using the stainer
  type: numeric
  unit: g/l

- displayed_name: Csand_sampling_sup400_stainer
  long_name: Sand concentration larger than 400 micrometres using the stainer
  description: >
    Suspended sand concentration of particles larger than 400 micrometres in
    measurements using the stainder
  type: numeric
  unit: g/l

Missing data codes: NA

## File 13 _____________________________________________________________________
Filename: data-literature_Payen-2024_lab.csv

Path: .

Description: >
  Data collected during the MSc thesis by S. Payen at the Compagnie National du
  Rhone, France in 2024 in the laboratory as a follow-up from Benoit (2023). A
  pump sampler PP36 using a stainer was deployed to collected suspended sand
  concentration in the center of the flume.

Column information:

- displayed_name: Type
  long_name: Nozzle type and orientation in the flow
  description: >
    Nozzle type and its orientation used for the pump sampler exposed in the
    center of the flume. Different nozzle orientations (perpendicular or
    parallel to the main flow direction) were deployed.
  type: character
  allowed_values:
    - Stainer parallel
    - Stainer perpendicular

- displayed_name: Serie
  long_name: Measurement series
  description: Measurement series conducted on different days
  type: integer

- displayed_name: Ratio_velocity
  long_name: Velocity ratio between sampling velocity and flow velocity
  description: >
    Velocity ratio between sampling velocity and mean flow velocity (1.25 m/s)
  type: numeric

- displayed_name: Velocity_sampling_m_s
  long_name: Sampling velocity
  description: Sampling velocity, corresponding to the pumping velocity
  type: numeric
  unit: m/s

- displayed_name: Sampling_duration_s
  long_name: Sampling duration
  description: Duration of the sampling during which suspension was pumped 
  type: numeric
  unit: s

- displayed_name: Csand_sampling
  long_name: Suspended sand concentration
  description: >
    Suspended sand concentration measured using the pump sampler with the
    indicated nozzle and orientation
  type: numeric
  unit: g/l

- displayed_name: Ratio_conc
  long_name: >
    Ratio between the concentration collected by the sampler and the reference
    concentration
  description: >
    Ratio between the concentration collected by the sampler and the reference
    concentration
  type: numeric

- displayed_name: Csand_ref
  long_name: Reference sand concentration
  description: Reference sand concentration measured at the outlet of the flume
  type: numeric
  unit: g/l

Missing data codes: NA

## File 14 _____________________________________________________________________
Filename: meta_cross-section-area_Grenoble-Campus.csv

Path: .

Description: >
  Includes cell sizes and number of cells of ADCP measurements for samplings in
  the Isère River at Grenoble Campus, used for the conversion of total fluxes
  through the cross-section to fluxes in kg/m2/s to compare with literature
  data in the discussion.

Column information:

- displayed_name: Date
  long_name: Sampling date
  description: Date when the sampling campaign was performed
  type: Date

- displayed_name: X_cell_size_m
  long_name: Width of ADCP cell size
  description: >
    Width of any ADCP cell size in a homogeneous grid in the cross-section
  type: numeric
  unit: m

- displayed_name: Y_cell_size_m
  long_name: Height of ADCP cell size
  description:
  type: numeric
  unit: m

- displayed_name: N_cells
  long_name: Number of ADCPs in the cross-section
  description:
  type: integer
  unit: -

- displayed_name: Area_m2
  long_name: Wet area of the measurement cross-section
  description:
  type: numeric
  unit: m2

Missing data codes: NA
