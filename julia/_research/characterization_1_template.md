# Initial Set-Up

## Activating Project Environment

```
```

## Packages Used in Analysis

```

```

Package descriptions:


# Introduction

## Background

The intent of this report is to investigate the characterization statement:

> **Characterization Statement 1:** Characterize the individuals being seen for mental health care services (related to depression, bipolar disorder, and suicidality) at least one time – including hospitalization events.

This characterization statement is founded on the central research topic for this study:

> **Research Topic:** Based on [CLAIMS], we see X% of all persons with at least one claim indicating [DEPRESSION/BIPOLAR DISORDER/SUICIDALITY] are not seen again.

By which the phrases "…all persons…" refer to those seen by patience care provider, etc. and "…are not seen again." implies lack of adherence to care.

## Data Sources Used

<!--TODO: Add information about data used in this particular report-->

# Data Analysis Preparation

## Creating Initial Connection

Defining connection details for connecting to a given database:

```
```

## Creating Initial OMOP Tables

In this case, the schema follows the [OMOP CDM v5](https://ohdsi.github.io/CommonDataModel/index.html) schema:

```
```

For this analysis, we will work with the following tables from the schema:

```
```

<!--TODO: Add description on what these tables are from the Book of OHDSI-->
Per the [Book of OHDSI], here are the break downs for these tables:

- `PERSON` - 
- `LOCATION` - 
- `OBSERVATION_PERIOD` - 
- `CONDITION_OCCURRENCE` -

# Cohort Populations

## General Cohort

### Overall Trends

#### Patient Spread

This calculates the number of patients in the dataset:

```
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- State
- Age
- Race
- Gender
- Care setting

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

## Inpatient Cohort

### Overall Trends

#### Patient Spread

This calculates the number of patients in the dataset:

```
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- State
- Age
- Race
- Gender
- Care setting

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

### General Trends for Bipolar Disorder

#### Patient Spread

This calculates the number of inpatient patients in the dataset:

```
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- Condition
- State
- Age
- Race
- Gender
- Care setting

##### Condition Breakdown

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

### General Trends for Depression

#### Patient Spread

This calculates the number of patients in the dataset:

```
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- Condition
- State
- Age
- Race
- Gender
- Care setting

##### Condition Breakdown

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

### General Trends for Suicidality

#### Patient Spread

This calculates the number of patients in the dataset:

```
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- Condition
- State
- Age
- Race
- Gender
- Care setting

##### Condition Breakdown

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

## Outpatient Cohort

### Overall Trends

#### Patient Spread

This calculates the number of outpatients in the dataset:

```
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- State
- Age
- Race
- Gender
- Care setting

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

### General Trends for Bipolar Disorder

#### Patient Spread

This calculates the number of outpatient patients in the dataset:

```
 
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- Condition
- State
- Age
- Race
- Gender
- Care setting

##### Condition Breakdown

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

### General Trends for Depression

#### Patient Spread

This calculates the number of patients in the dataset:

```
 
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- Condition
- State
- Age
- Race
- Gender
- Care setting

##### Condition Breakdown

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown

### General Trends for Suicidality

#### Patient Spread

This calculates the number of patients in the dataset:

```
 
```

In this dataset, there are `[CALCULATE PATIENTS]` patients.
To further examine this data, we can break them down across the following axes:

- Condition
- State
- Age
- Race
- Gender
- Care setting

##### Condition Breakdown

##### State Breakdown

##### Age Breakdown

##### Racial Breakdown

##### Gender Breakdown

##### Care Site Breakdown
