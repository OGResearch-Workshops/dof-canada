# Simulation and Estimation Techniques in the Iris Toolbox

## Workshop for the Department of Finance Canada

## Dependencies

* Matlab - any recent version not older than R2019b

* [Git](git-scm.com)


## Test

1. Clone the workshop repository on your computer by running the following
   command line

```
git clone https://github.com/OGResearch-Workshops/workshop-dof-canada.git
```

This command will create a new folder `workshop-dof-canada`. with the
following structure

```
workshop-dof-canada
|-- README.md
|-- iris-toolbox/
|-- test/
|-- simulation/
|-- estimation/
```


2. Open Matlab and switch to the `workshop-dof-canada/test` folder

3. Start the Iris Toolbox up

```
>> addpath ../iris-toolbox; iris.startup()
```

4. Run the test model

```
>> run01_createModel
>> run07_simulateComplexShocks
```

You will see a lot of screen output and some figures plotted. You should
not see any errors or warning messages.


