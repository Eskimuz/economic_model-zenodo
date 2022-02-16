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

--model (insert local path to folder here/ "Industrial-Revolution-17-01-2022.netlogo") \
--experiment "low-initial-wages-no-government" 
--table "(insert path here)" 
--experiment "low-initial-wages-yes-government" 
--table "(insert path here)" 
--experiment "high-initial-wages-no-government" 
--table "(insert path here)" 
--experiment "high-initial-wages-yes-government" 
--table "(insert path here)" 


use table command for setting the output destination, names are already in experiment. Path should use \ to separate folders  

details on table vs spreasheet command
https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html#run-options-formats


output should be automatic


XML HERE

https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html#setting-up-experiments-in-xml

I don't understand how to run it tho, the instructions are there
  

to do:

- program the headless function of netlogo
- run the 3.6 million simulations
- create a pipeline for analyzing the results

look into https://pynetlogo.readthedocs.io/en/latest/install.html

# Docker image
The image is in docker hub with this name biocorecrg/econ:0.01



