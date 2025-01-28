# MAKAHO [<img src="https://github.com/super-lou/MAKAHO/blob/cf59042ee48e7ada24d89ae8fa7f7878cff3eb26/www/MAKAHO.png" align="right" width=100 height=100 alt=""/>](https://makaho.sk8.inrae.fr/)

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-green)](https://lifecycle.r-lib.org/articles/stages.html)
![](https://img.shields.io/github/last-commit/super-lou/MAKAHO)
[![](https://img.shields.io/badge/Shiny-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://makaho.sk8.inrae.fr/)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md) 
<!-- badges: end -->

[MAKAHO](https://makaho.sk8.inrae.fr/) stands for MAnn-Kendall Analysis of Hydrological Observations.

It is a [R Shiny](https://shiny.rstudio.com/) website based on [EXstat](https://github.com/super-lou/EXstat) package with [CARD](https://github.com/super-lou/CARD) code bundle. It provides an interactive cartographic solution to analyze the hydrological stationarity of French surface flows based on the data of the hydrometric stations where the flows are little influenced by the human actions.

[<img src="https://github.com/super-lou/MAKAHO/blob/2f1ea7fab7c867041d707cee1bd68d5c3b3bfd04/www/screen.png" width="600">](https://makaho.sk8.inrae.fr/)

Data came from [Hydroportail](https://www.hydro.eaufrance.fr/) and the selection of stations follows the Reference Network for Low Water Monitoring (Réseau de référence pour la surveillance des étiages, [RRSE](https://geo.data.gouv.fr/en/datasets/29819c27c73f29ee1a962450da7c2d49f6e11c15) in french).

A part of the data produced by [MAKAHO](https://makaho.sk8.inrae.fr/) can be downloaded from [Recherche Data Gouv](https://doi.org/10.57745/LNBEGZ).

This project was carried out for National Research Institute for Agriculture, Food and the Environment (Institut National de Recherche pour l’Agriculture, l’Alimentation et l’Environnement, [INRAE](https://agriculture.gouv.fr/inrae-linstitut-national-de-recherche-pour-lagriculture-lalimentation-et-lenvironnement) in french).


## Installation
If you want to visit the website hosted by the [SK8 project](https://sk8.inrae.fr/), you can go to this URL: [https://makaho.sk8.inrae.fr/](https://makaho.sk8.inrae.fr/).

If you want a local instance, you can download the latest development version using:
```
git clone https://github.com/super-lou/MAKAHO.git
```

The input data needed are not hosted on GitHub but can be found on [Recherche Data Gouv](https://doi.org/10.57745/1BBH2Y). This data is in a long format `dplyr::tibble` with concatenated hydrometric station data gathered from [Hydroportail](https://www.hydro.eaufrance.fr/). There is a file named `script_create.R` that can help you format such a data table using the [ASHE](https://github.com/super-lou/ASHE) package.

The local personalized instance has not been properly tested yet but can be a potential area for future improvement!


## Help
You can find an interactive help on the website if you press the bottom right interrogation button.


## FAQ
*I have a question.*

-   **Solution**: Search existing issue list and if no one has a similar question create a new issue.

*I found a bug.*

-   **Good Solution**: Search existing issue list and if no one has reported it create a new issue.
-   **Better Solution**: Along with issue submission provide a minimal reproducible example of the bug.
-   **Best Solution**: Fix the issue and submit a pull request. This is the fastest way to get a bug fixed.


## Code of Conduct
Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
