# economic_model
revenge against capitalism

programs needed: Netlogo and Java. 
Netlogo requires Java-Home to be specified for running headless
runs can be programmed directly in XML (I'm not familiar tho, you?)

Netlogo has a built in Monte-Carlo simulator called behaviorspace: https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html

Run new file Industrial-Revolution-17-01-2022, rewritten and corrected:


in installation folder run netlogo.headless

--model (insert local path to folder here/ "nameofthemodel.netlogo") \
--experiment "experiment1"
--table <path> or --spreadsheet <path>
  
use table/spreadsheet command for setting the output destination, names are already in experiment  


output should be automatic


to do:

- program the headless function of netlogo
- run the 3.6 million simulations
- create a pipeline for analyzing the results

look into https://pynetlogo.readthedocs.io/en/latest/install.html
