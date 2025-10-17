# CoverageAnalysisAndPlottingSuite
CAPS (Coverage Analysis and Planning Suite) is a MATLAB-based application designed for radar coverage analysis, sensor line-of-sight computation, and geospatial visualization.
The suite integrates GIS data, terrain modeling, and sensor configuration utilities to provide mission-level coverage planning, visualization, and reporting capabilities.
CAPS enables users to:
Load and visualize base station and survey point data on interactive maps.
Perform multi-site coverage analysis using topographic and terrain data.
Automatically generate professional survey reports in PDF format with annotated figures and LOS diagnostics.
Interface with GNSS receivers such as u-blox M10 for live geolocation tagging.
Log survey progress, remarks, and overlay critical data such as city boundaries and roads.
The app supports geospatial zooming, multi-resolution basemaps, intelligent redraw handling, and user-defined annotations for site planning and documentation. CAPS is optimized for field use as well as offline post-survey reporting, streamlining the full coverage survey lifecycle from planning to documentation.

🛰️ Key Features

Sector and 360° Coverage Analysis — Compute and visualize line-of-sight (LoS) and non-line-of-sight (NLoS) regions for radar/sensor sites.

Multi-site Processing — Analyze coverage interaction across multiple transmit/receive sites.

GDoP Heatmap Computation — Geometric Dilution of Precision visualization for positioning and network optimization.

Interactive Map Visualization — Built on MATLAB’s geographic plotting engine for accurate terrain-mapped outputs.

Report Generation — Automated PDF and Excel-based report generation through integrated Report Generator support.

Modular Architecture — Clean folder-level segregation of computational modules, GUI logic, and helper scripts.
