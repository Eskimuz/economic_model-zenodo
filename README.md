# economic_model
revenge against capitalism

programs needed: Netlogo and Java. 
Netlogo requires Java-Home to be specified for running headless, see https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html#examples
runs can be programmed directly in XML (I'm not familiar tho, you?)

Netlogo has a built in Monte-Carlo simulator called behaviorspace: https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html

Run new file Industrial-Revolution-17-01-2022, rewritten and corrected:
-fixed loop bug
-fixed bourgeoisie behavior
-new generation of firms that follows population
-no foreign market
-no unemployment random money generation
-government feature can be switched off

in installation folder run netlogo.headless

--model (insert local path to folder here/ "nameofthemodel.netlogo") \
--experiment "experiment1"
--table "path" 
  
use table command for setting the output destination, names are already in experiment. Path should use \ to separate folders  

details on table vs spreasheet command
https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html#run-options-formats


output should be automatic


to do:

- program the headless function of netlogo
- run the 3.6 million simulations
- create a pipeline for analyzing the results

look into https://pynetlogo.readthedocs.io/en/latest/install.html
