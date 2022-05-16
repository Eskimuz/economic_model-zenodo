# Spinning Jenny

This pipeline requires Nextflow and one between Docker or Singularity. For installing Nextflow type:

```
curl -s https://get.nextflow.io | bash
```

- For Docker follow the instructions here: https://docs.docker.com/get-docker/
- For Singularity instead: https://sylabs.io/guides/latest/admin-guide/installation.html

## Docker images
Tools needed for running the pipelines are wrapped into docker images and stored in DockerHub. They are automatically retrieved by Nextflow. 

## Installing the pipeline
You can clone the repository by doing

```
git clone git@github.com:lucacozzuto/economic_model.git
```

## Installing the pipeline

Then you can launch it specifying either docker or singularity engines:

With Docker:

```
cd economic_model;

nextflow run  main.nf -with-docker -bg  > log
``` 

or with Singularity:

```
nextflow run  main.nf -with-singularity -bg  > log
```

## Input and Output
The inputs are specified within the file **params.config** tha contains:

- the number of batches: number of times you want to run each execution to obtain 8 repetitions per batch.
- the template xml file name
- the values file name
- the output folder name

You can change those default values by editing the file or using two dashes (**--**) when running the pipeline:

```
nextflow run  main.nf -with-singularity -bg --batches 125 > log
```

The file **template** contains the **xml** needed by NetLogo for running the model. The default one is named template.xml and given in this repository.
The file **values** contains the name of the parameters and their starting, final and step values for making several simulations. The output of those simulation will be named:

```
PLOTS -> {PARAMETER_NAME}_{VALUE}_{PLOT_ID}.pdf 
TXT   -> {PARAMETER_NAME}_{VALUE}_{PLOT_ID}._cat.txt 
```

The default file for value is **values.txt** and will give those files as output:

```
initial-labor-price_10_1.pdf    initial-labor-price_15_3.pdf
initial-labor-price_10_2.pdf    initial-labor-price_15_cat.txt
initial-labor-price_10_3.pdf    initial-labor-price_5_1.pdf
initial-labor-price_10_cat.txt  initial-labor-price_5_2.pdf
initial-labor-price_15_1.pdf    initial-labor-price_5_3.pdf
initial-labor-price_15_2.pdf    initial-labor-price_5_cat.txt

```


## Running the pipeline in a cluster
We provide multiple configuration for running the pipeline in different environments. Just using different profiles will allow to use different specifications. For example running the pipeline in a SGE based cluster will be:

```
nextflow run main.nf -with-singularity -profile sge -bg > log.txt
```

We provide the following possibilities:

- awsbatch
- sge
- slurm
- local




