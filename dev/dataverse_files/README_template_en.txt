RDG README File Template --- General --- Version: 0.1 (2022-10-04) 
 
This README file was generated on [YYYY-MM-DD] by [NAME].
Last updated: [YYYY-MM-DD].

# GENERAL INFORMATION
 
## Dataset title:
 
## DOI:
 
## Contact email:
 
<Here is a list of suggested items to help you enrich your documentation if necessary. Some may not be applicable, depending on the dataset’s discipline or context of production.>
 
<***Remove or add any section if applicable***>
 
# METHODOLOGICAL INFORMATION 
 
## Environmental/experimental conditions: 
 
## Description of sources and methods used to collect and generate data:
<If applicable, describe standards, calibration information, facility instruments, etc. > 
 
## Methods for processing the data: 
< If applicable, describe how submitted data were processed and include details that may be important for data reuse or replication. Add comments to explain each step taken.
For example, include data cleaning and analysis methods; code and/or algorithms, de-identification procedures for sensitive data human subjects or endangered species data.> 
 
## Quality -assurance procedures performed on the data: 
 
## Other contextual information:
<Any information that you consider important for the evaluation of the dataset’s quality and reuse thereof: for example, information about the software required to interpret the data. 
If applicable and not covered above, include full name and version of software, and any necessary packages or libraries needed to read and interpret the data, *e.g.* to run scripts.>
 
 
# DATA & FILE OVERVIEW
 
 
## File naming convention:
 
## File hierarchy convention:
 
 
# DATA-SPECIFIC INFORMATION FOR: [FILENAME]
 
<Repeat this section for each folder or file, as appropriate. Recurring items may also be explained in a common initial section.>
 
<For tabular data, provide a data dictionary/code book containing the following information:>
## Variable/Column List:
For each variable or column name, provide: 

	-- full “human readable” name of the variable, 
	-- description of the variable, 
	-- unit of measurement if applicable, 
	-- decimal separator *i.e.* comma or point if applicable
	-- allowed values : list of values or range, or domain
	-- format if applicable, e.g. date>
 
## Missing data codes: 
<Define codes or symbols used to indicate missing data.>
 
## Additional information: 
<Any relevant information you consider useful to better understand the file>








Suspended-sand measurements at three sampling sites in the Isere River catchment using US P-6, Delft bottle and pump PP36 as well as flume experiments using the pump PP36 and digitized data from the literature (Dijkman & Milisic (1982) and Beverage & Williams (1989).

This dataset is composed of suspended sand concentration and grain size data used for the evaluation of suspended sediment samplers. The data were collected at three different study sites in the French Isère River catchment. One site is located in the Isère River at Grenoble Campus, the second site in the Arc River at Chamousset and another one in the Romanche River at Pont Rouge. Several specific suspended sand and sediment samplers were used: the US P-6, the Delft bottle and the novel pump PP36. Field sites, samplers and measurement protocols are described in detail in the article. Sand concentration of liquid samples taken using the US P-6 were determined by filtration after separating the fine sediment fraction (< 63 µm). Filters were dried at 104°C and weighed to determine the dry sand mass. Solid sediment samples obtained by the other two samplers were sieved at 63 µm in the field. In the laboratory, large organic particles were removed manually, the samples were dried at 104°C for 12 hours and weighed. Sand fluxes determined by the Delft bottle were converted using velocity measurements with Acoustic Doppler Current Profiler or measurement reels to point sand concentrations.

Precisely, the provided files are :
- Comparison_BD_gaugings: includes cross-sectional averages of sand concentration, flux, grain size and uncertainties for samplings with the Delft bottle; used for IDs 1 and 3
- Comparison_P6_gaugings: includes cross-sectional averages of sand and fine-sediment concentration, flux, grain size and uncertainties for samplings with the US P-6; used for IDs 1 and 3
- Comparison_ pump_ P6_point: includes point sand concentrations collected simultaneously with the US P-6 and the pump PP36 at all three sites, used for ID 5
- Comparison_pump_ P6_XS: includes cross-sectional averages of sand concentration and flux collected with the US P-6 and the pump PP36 in the Isère River at Grenoble Campus; used for ID 2
- Comparison_pump_ P6_GSD: includes point sand grain size collected with the US P-6 and the pump PP36 at all three sites; used for ID 4
- Comparison_BD_pump_point: includes point sand concentration and flux collected with the Delft bottle and the pump PP36 in the Isère River at Grenoble Campus; used for ID 6
- Area_cross_section_Grenoble_Campus_XS: includes cell sizes and number of cells of ADCP measurements for samplings in the Isère River at Grenoble Campus, used for the conversion of total fluxes through the cross-section to fluxes in kg/m2/s to compare with literature data in the discussion

Also included are datasets from four other studies in seven files. First, there are the datasets produced during two internships at the Compagnie National du Rhone (CNR), by Florian Benoit et Samuel Payen. Their data is included in the main part of the article and has not been published elsewhere. Data by SPayen is split into the measurements obtained in the laboratory and those in the field. Second, there are the datasets from sampler comparison studies performed by Dijkman and Milisic (1982) and Beverage and Williams (1989). The data from Dijkman and Milisic (1982) was digitized from an appendix of their report and is included here for completeness and to provide the data in a reusable form. Data from Beverage and Williams (1989) was digitized from their figures in their article using WebPlotDigitizer (https://apps.automeris.io/wpd4/), which may introduce errors. However, as this data is used for comparison purposes only, we assume the error is negligible. The data is split into three files, each for another grain size class, 62 – 125 μm, 125 – 250 μm and all sand sized-particles larger than 62 μm. 
