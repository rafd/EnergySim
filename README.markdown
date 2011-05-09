EnergySim
=========

A energy-based neighbourhood simulation. The goal is to provide a platform for evaluating various technology scenarios in terms of economic and environmental sustainability. 

Project consists of a Modelica library for neighbourhood-scale energy-flow modelling and various technology scenarios for the Annex neighbourhood in Toronto, Canada.

This project is being completed as part of the 2011 Energy Systems Engineering Capstone project for the Engineering Science division at the University of Toronto.


Project Team
------------

### Modelling Team
* Kun Xie ([xiekun](http://github.com/xiekun/))
* Rafal Dittwald ([rafd](https://github.com/rafd/))
* Sean Yamana ([seanamana](https://github.com/seanamana/))
* Marina Freire-Gormaly ([mfg](https://github.com/mfg/))

### Neighbourhood Team

### Technology Team



Set Up
------

Setting the appropriate OpenModelica Path:

  * in terminal (or equivalent), run OMShell
  * in OMShell, run: getSettings() and copy down the part after the first : (should end in /common)
    * for example: /opt/local/lib/omlibrary/common
  * exit OMShell
  * cd to the directory you noted down above
  * run: ln -s /path/to/this/repo /path/to/directory/above
    * for example: ln -s ~/Code/EnergySim /opt/local/lib/omlibrary/common
    * may require sudo