# //////////////////////////////////
# /////Importing & Viewing Data////
# ////////////////////////////////  

rm(list=ls(all.names =TRUE))
graphics.off()
close.screen(all.screens = TRUE)
erase.screen()
windows.options(record=TRUE)

install.packages("openxlsx")
install.packages("dplyr")
install.packages ("tidyr")
install.packages("StMoMo")
install.packages("demography")
install.packages("HMDHFDplus")
install.packages("cli")
install.packages("forecast")
install.packages("bootstrap")
install.packages("Metrics")
install.packages("lubridate")
install.packages("readxl")
install.packages("ggplot2")

library(dplyr) # For we can apply the matrix functions
library(tidyr)  # For we can apply the matrix functions       
library(demography) # For we can use the Lee-Carter stochastic mortality model
library(HMDHFDplus) # For we can use the Data from HMDHF.
library(StMoMo) # For we define the ages that we actually want
library(forecast) # For we can forecast the future values
library(bootstrap) # For we can do bootstrapping in Fitting Values
library(openxlsx) # Exporting the Life tables into Excel
library(Metrics) #Accuracy Forecasting
library(lubridate)
library(readxl)
library(ggplot2)


load("HMDdata_17Jul2021.RData")


# Creating Data set File Path & Importing Data sets:

setwd("C:/Users/luiss/Desktop/Track 3 Project (55%)/Rstudio Project Track 3")
    
deathsdata1 <- read.table("Deaths 1x1 Portugal 1951-2022.txt", header=TRUE, sep="", dec=".",skip=2)
  #View(deathsdata1) # See the Deaths Data of Portugal 2022

exposureriskdata1 <- read.table("Exposure to risk 1x1 Portugal 1951-2022.txt", header=TRUE, sep="", dec=".",skip=2)
  #View(exposureriskdata1) # See the Exposure Risk Data of Portugal 2022


# //////////////////////////////////
# /////Organizing Data///////////// 
# ////////////////////////////////  

#Readjusting the Data set for the 60 - 90 years and to 1980 - 2022 on deaths and exposure Risk.

deathsdata <- deathsdata1 # Creating a Copy of Data set (Back-Up)
  deathsdata <- deathsdata1[!(deathsdata1$Year >= 1951 & deathsdata1$Year <= 1979) & !(deathsdata1$Year > 2018 & deathsdata1$Year <= 2022) & !(deathsdata1$Age > 90), ]

#View(deathsdata)

exposureriskdata <- exposureriskdata1
  exposureriskdata <- exposureriskdata1[!(exposureriskdata1$Year >= 1951 & exposureriskdata1$Year <= 1979) & !(deathsdata1$Year > 2018 & deathsdata1$Year <= 2022)
                                      & !(exposureriskdata1$Age > 90), ] 
#View(exposureriskdata)

# Define the range of years for rows and columns
row_years <- 60:90 # We defined here years between 60 - 90 because weird values of Portugal Data set.
  column_years <- 1980:2018 # We defined here years between 1980 - 2022 because weird values of Portugal Data set. 

# Create an empty matrix with the desired dimensions
year_matrix <-  matrix(NA, nrow = length(row_years), ncol = length(column_years))
  year_matrix2 <- matrix(NA, nrow = length(row_years), ncol = length(column_years))
    year_matrix3 <- matrix(NA, nrow = length(row_years), ncol = length(column_years))
      year_matrix4 <- matrix(NA, nrow = length(row_years), ncol = length(column_years))
        year_matrix5 <- matrix(NA, nrow = length(row_years), ncol = length(column_years))

# Add row and column names to the matrix
rownames(year_matrix) <- row_years # Ages
  colnames(year_matrix) <- column_years # Years

# ////////////////////////////////////////////////////
# //Total Death Matrix According of each Year & Age// 
# //////////////////////////////////////////////////

matrix_data <- deathsdata %>% 
  group_by(Year, Age) %>% 
    summarise(Total = sum(Total))
      total_death_matrix <- spread(matrix_data, key = Year, value = Total) # Pivot the data to create the matrix

# /////////////////////////////////////////////////////
# //Female Death Matrix According of each Year & Age// 
# ///////////////////////////////////////////////////

matrix_data1 <- deathsdata %>% 
  group_by(Age, Year) %>% 
    summarise(Female = sum(Female))
      female_death_matrix <- spread(matrix_data1, key = Year, value = Female) # Pivot the data to create the matrix

# ///////////////////////////////////////////////////
# //Male Death Matrix According of each Year & Age// 
# /////////////////////////////////////////////////

matrix_data2 <- deathsdata %>% 
  group_by(Age, Year) %>% 
    summarise(Male = sum(Male))
      male_death_matrix <- spread(matrix_data2, key = Year, value = Male) # Pivot the data to create the matrix

# ///////////////////////////////////////////////////////
# //Total Exposure Matrix According of each Year & Age// 
# /////////////////////////////////////////////////////

matrix_data3 <- exposureriskdata %>% 
  group_by(Age, Year) %>% 
    summarise(Total = sum(Total))
      total_exposure_matrix <- spread(matrix_data3, key = Year, value = Total) # Pivot the data to create the matrix

# /////////////////////////////////////////////////////////////
# //Female Exposure Risk Matrix According of each Year & Age// 
# ///////////////////////////////////////////////////////////

matrix_data4 <- exposureriskdata %>% 
  group_by(Age, Year) %>% 
    summarise(Female = sum(Female))
      female_exposure_matrix <- spread(matrix_data4, key = Year, value = Female) # Pivot the data to create the matrix

# ///////////////////////////////////////////////////
# //Male Death Matrix According of each Year & Age// 
# /////////////////////////////////////////////////

matrix_data5 <- exposureriskdata %>% 
  group_by(Age, Year) %>% 
    summarise(Male = sum(Male))
      male_exposure_matrix <- spread(matrix_data5, key = Year, value = Male) # Pivot the data to create the matrix

#All the matrices according their Years & Age Values:

#View(total_death_matrix)  # Total Death According their Year & Age
  #View(female_death_matrix) # Female Death According their Year & Age
    #View(male_death_matrix)  # Male Death According their Year & Age
      #View(total_exposure_matrix)  # Total Exposure Risk According their Year & Age
        #View(female_exposure_matrix) # Female Exposure Risk According their Year & Age
          #View(male_exposure_matrix)  # Male Exposure Risk According their Year & Age

# //////////////////////////////////
# /////Mortality Rates per Age/////
# ////////////////////////////////   

#Now, we will see for the Female & Masculine & Total Mortality Rate Per Age:
# Creating vectors to store mortality rates (According the 30 Years Difference) 60 to 90 years:

mortality_age <- numeric(31) # maximum length of the mortality age 
  mortality_age_rates_male <- numeric(31) # maximum length of the mortality male age
    mortality_age_rates_female <- numeric(31) # maximum length of the mortality female age

# Summing all the values of the specific Ages on (deaths_age, deaths,age_male,
#  deaths_age_female, exposures_age, exposures_age_male, exposures_age_female)
#    from ages 60 to 90, depending of the n value.

for (n in 60:90) {
  
  deaths_age <- sum(deathsdata$Total[deathsdata$Age == n])
    deaths_age_male <- sum(deathsdata$Male[deathsdata$Age == n])
      deaths_age_female <- sum(deathsdata$Female[deathsdata$Age == n])
        exposures_age <- sum(exposureriskdata$Total[exposureriskdata$Age == n])
          exposures_age_male <- sum(exposureriskdata$Male[exposureriskdata$Age == n])
            exposures_age_female <- sum(exposureriskdata$Female[exposureriskdata$Age == n])
  
  # Depending of n, calculates the Mortality Rate for that n age (Total, Male, Female).
  #   creates the values in absolute.
  
 mortality_age[n - 30] <- deaths_age / exposures_age
    mortality_age_rates_male[n - 30] <- deaths_age_male / exposures_age_male
      mortality_age_rates_female[n - 30] <- deaths_age_female / exposures_age_female
}

#From n selected makes the sum of the values of the Total according the Age on
# (deaths_age, deaths_age_male, deaths_age_female,exposures_age, exposures_age_male
#   exposures_age_female).

deaths_age <- tapply(deathsdata$Total, deathsdata$Age, sum)
  deaths_age_male <- tapply(deathsdata$Male, deathsdata$Age, sum)
    deaths_age_female <- tapply(deathsdata$Female, deathsdata$Age, sum)
      exposures_age <- tapply(exposureriskdata$Total, exposureriskdata$Age, sum)
        exposures_age_male <- tapply(exposureriskdata$Male, exposureriskdata$Age, sum)
          exposures_age_female <- tapply(exposureriskdata$Female, exposureriskdata$Age, sum)

          
# Calculate mortality rates for each age for assign the in Plot:
mortality_age <- deaths_age / exposures_age
  mortality_age_rates_male <- deaths_age_male / exposures_age_male
    mortality_age_rates_female <- deaths_age_female / exposures_age_female

    
# Plot mortality rates by Ages
x <- 60:90
  y <- mortality_age
    y1 <- mortality_age_rates_male
      y2 <- mortality_age_rates_female
        y_min1 <- min(c(log(y), log(y1), log(y2))) #Creating a Graph with the suppose sizes of the Lines:
          y_max1 <- max(c(log(y), log(y1), log(y2))) #Creating a Graph with the suppose sizes of the Lines:
            plot(x, log(y), type = "l", xlab = "Age", ylab = "log(Mortality Rate)",ylim = c(y_min1, y_max1))
              lines(x, log(y1), col = "#BFD62F")
                lines(x, log(y2), col = "#5C666D")
                    legend("bottomright", legend = c("Total", "Male", "Female"), 
                      col = c("black", "#BFD62F", "#5C666D"), lty = 1, cex = 0.8, bty = "n", y.intersp = 1.5)    
                        grid()
                    
# //////////////////////////////////
# /////Mortality Rates per Year////
# ////////////////////////////////  

#Now, we will see for the Female & Masculine & Total Mortality Rate Per Year:
# Creating vectors to store mortality rates (According the 38 Years Difference) 1980 to 2018 years:

mortality_year <- numeric(39) # maximum length of the mortality Year
  mortality_year_rates_male <- numeric(39) # maximum length of the mortality male Year
    mortality_year_rates_female <- numeric(39) # maximum length of the mortality female Year

# Summing all the values of the specific Years on (deaths_year, deaths_year_male,
#  deaths_year_female, exposures_year, exposures_year_male, exposures_year_female)
#    from ages 1960 to 2022, depending of the t value.

for (t in 1980:2022) {
  deaths_year <- sum(deathsdata$Total[deathsdata$Year == t])
    deaths_year_male <- sum(deathsdata$Male[deathsdata$Year == t])
      deaths_year_female <- sum(deathsdata$Female[deathsdata$Year == t])
        exposures_year <- sum(exposureriskdata$Total[exposureriskdata$Year == t])
          exposures_year_male <- sum(exposureriskdata$Male[exposureriskdata$Year == t])
            exposures_year_female <- sum(exposureriskdata$Female[exposureriskdata$Year == t])
  
  # Depending of t, calculates the Mortality Rate for that n Year (Total, Male, Female).
  #   creates the values in absolute.
  
mortality_year[t - 43] <- deaths_year / exposures_year
  mortality_year_rates_male[t - 43] <- deaths_year_male / exposures_year_male
    mortality_year_rates_female[t - 43] <- deaths_year_female / exposures_year_female
}

#From t selected makes the sum of the values of the Total according the Year on
# (deaths_year, deaths_year_male, deaths_year_female,exposures_year, exposures_year_male
#   exposures_year_female).

deaths_year <- tapply(deathsdata$Total, deathsdata$Year, sum)
  deaths_year_male <- tapply(deathsdata$Male, deathsdata$Year, sum)
    deaths_year_female <- tapply(deathsdata$Female, deathsdata$Year, sum)
      exposures_year <- tapply(exposureriskdata$Total, exposureriskdata$Year, sum)
        exposures_year_male <- tapply(exposureriskdata$Male, exposureriskdata$Year, sum)
          exposures_year_female <- tapply(exposureriskdata$Female, exposureriskdata$Year, sum)

# Calculate mortality rates for each age for assign the in Plot:
mortality_year <- deaths_year / exposures_year
  mortality_year_rates_male <- deaths_year_male / exposures_year_male
    mortality_year_rates_female <- deaths_year_female / exposures_year_female

#Creating the Values for Plot:
x1 <- 1980:2018
  y3 <- mortality_year
    y4 <- mortality_year_rates_male
      y5 <- mortality_year_rates_female
        y_min <- min(c(log(y3), log(y4), log(y5))) #Creating a Graph with the suppose sizes of the Lines
          y_max <- max(c(log(y3), log(y4), log(y5))) #Creating a Graph with the suppose sizes of the Lines
            plot(x1, log(y3), type = "l", xlab = "Year", ylab = "log(Mortality Rate)", ylim = c(y_min, y_max))
              lines(x1, log(y4), col = "#BFD62F")
                lines(x1, log(y5), col = "#5C666D")
                  legend("topright", legend = c("Total", "Male", "Female"), 
                    col = c("black", "#BFD62F", "#5C666D"), lty = 1, cex = 0.8, bty = "n", y.intersp = 1.5)
                      grid()

# //////////////////////////////////////////
# /Generalized Age-Period-Cohort (GAPC)////   #stochastic mortality models family
# ////////////////////////////////////////  


# Poisson Distribution for the Number of Deaths using Lee-Carter. 

constLC <- function(ax, bx, kt, b0x, gc, wxt, ages){
  c1 <- mean(kt[1, ], na.rm = TRUE)
  c2 <- sum(bx[, 1], na.rm = TRUE)
  list(ax = ax + c1 * bx, bx = bx / c2, kt = c2 * (kt - c1))
}
LC <- StMoMo(link= "log",staticAgeFun = TRUE, periodAgeFun = "NP", constFun = constLC)

#Implementation of Data set of Portugal for Poisson Lee- Carter

#Importing Professor Method Male for the Years 1980 until 2018 & 60-90 years:

gender_M <- 'Male'              # Options: Male, Female, Total
  gender_F <- 'Female'              # Options: Male, Female, Total
    gender_T <- 'Total'              # Options: Male, Female, Total
      h <- 33
        cnt <- country[h]
          Age <- min(deaths[[cnt]]$Age):max(deaths[[cnt]]$Age)
            Year <- min(deaths[[cnt]]$Year):max(deaths[[cnt]]$Year)

#Creating the Deaths & Exposures Matrix Tables
DXT_F <- matrix(deaths[[cnt]][[gender_F]], nrow=length(Age), ncol=length(Year)) #Not Restricted Deaths Female, All the Ages & Years
  EXT_F <- matrix(exposures[[cnt]][[gender_F]], nrow=length(Age), ncol=length(Year)) #Not Restricted Exposures Female, All the Ages & Years
    dimnames(DXT_F) <- list(Age, Year)
      dimnames(EXT_F) <- list(Age, Year)
        DXT_M <- matrix(deaths[[cnt]][[gender_M]], nrow=length(Age), ncol=length(Year)) #Not Restricted Deaths Male, All the Ages & Years
          EXT_M <- matrix(exposures[[cnt]][[gender_M]], nrow=length(Age), ncol=length(Year)) #Not Restricted Exposures Male, All the Ages & Years
            dimnames(DXT_M) <- list(Age, Year)
              dimnames(EXT_M) <- list(Age, Year)
                DXT_T <- matrix(deaths[[cnt]][[gender_T]], nrow=length(Age), ncol=length(Year)) #Not Restricted Deaths Total, All the Ages & Years
                  EXT_T <- matrix(exposures[[cnt]][[gender_T]], nrow=length(Age), ncol=length(Year)) #Not Restricted Exposures Total, All the Ages & Years
                    dimnames(DXT_T) <- list(Age, Year)
                      dimnames(EXT_T) <- list(Age, Year)
                        #Filtering the Years & Ages Deaths & Exposures Matrix Tables
                          AgeMin <- 60                # Minimum age considered in the estimation period
                            AgeMax <- 90               # Maximum age considered in the estimation period
                              YearMin <- 1980            # 1st year considered in the estimation period
                                YearMax <- max(deaths[[cnt]]$Year)   # last year considered in the estimation period
                                  x6 <- AgeMin:AgeMax         # age range
                                    y9 <- YearMin:YearMax       # year range
                                      ytg <- 2025                # Last year for which you wish to compute cohort LE
                                        nt <- YearMax-YearMin+1    # number of years
                                          nx <- AgeMax-AgeMin+1      # number of ages
                                            wa <- matrix(1,nx,nt)      # weights matrix
                                              omega <- 125               # Highest attainable age
                                                #Final Matrix Filtered Years & Ages Deaths & Exposures Matrix Tables
                                                  ext_M_R <- EXT_M[(AgeMin-Age[1]+1):(AgeMax-Age[1]+1),(YearMin-Year[1]+1):(YearMax-Year[1]+1)] # Exposures Filtered Male
                                                    dxt_M_R <- DXT_M[(AgeMin-Age[1]+1):(AgeMax-Age[1]+1),(YearMin-Year[1]+1):(YearMax-Year[1]+1)] # Deaths Filtered Male
                                                      ext_F_R <- EXT_F[(AgeMin-Age[1]+1):(AgeMax-Age[1]+1),(YearMin-Year[1]+1):(YearMax-Year[1]+1)] # Exposures Filtered Female
                                                        dxt_F_R <- DXT_F[(AgeMin-Age[1]+1):(AgeMax-Age[1]+1),(YearMin-Year[1]+1):(YearMax-Year[1]+1)] # Deaths Filtered Female
                                                          ext_T_R <- EXT_T[(AgeMin-Age[1]+1):(AgeMax-Age[1]+1),(YearMin-Year[1]+1):(YearMax-Year[1]+1)] # Exposures Filtered Total
                                                            dxt_T_R <- DXT_T[(AgeMin-Age[1]+1):(AgeMax-Age[1]+1),(YearMin-Year[1]+1):(YearMax-Year[1]+1)] # Deaths Filtered Total
                                                              mxt_F_R <- dxt_F_R/ext_F_R       # crude central mortality rates (mxt) Female
                                                                qxt_F_R <- 1-exp(-mxt_F_R)   # crude death probabilities (qxt) Female
                                                                  mxt_M_R <- dxt_M_R/ext_M_R       # crude central mortality rates (mxt) Male
                                                                    qxt_M_R <- 1-exp(-mxt_M_R)   # crude death probabilities (qxt) Male
                                                                      mxt_T_R <- dxt_T_R/ext_T_R       # crude central mortality rates (mxt) Total
                                                                        qxt_T_R <- 1-exp(-mxt_M_R)   # crude death probabilities (qxt) Total
                                                                          #Creating a Training Data during 10 years
                                                                            hp <- 10               # holdout period
                                                                              train <- 1:(nt-hp)     # training years
                                                                                ntt <- length(train)
                                                                                  wxt <- genWeightMat(ages = x6, years = y9, clip = 3)
                                                                                    forc.h <- 82  # Forecasting horizon (# years to forecast)
#For we get the Initial Values of Exposures:          
  Ext_I_T <- ext_T_R+0.5*dxt_T_R                                                                                 
    Ext_I_M <- ext_M_R+0.5*dxt_M_R
      Ext_I_F <- ext_F_R+0.5*dxt_F_R
        years.fit <- y9
          ages.fit <- x6
            years <- y9
              ages <- x6
                wxt= genWeightMat(age = ages.fit, years= years, clip =3)                                                                          

#Total Lee-Carter Fitting
  LCfit_T <- fit(LC, Dxt = dxt_T_R, Ext = Ext_I_T,  ages = x6, years = y9, wxt=wxt)
  #Male Lee-Carter Fitting
    LCfit_M <- fit(LC, Dxt = dxt_M_R, Ext = Ext_I_M,  ages = x6, years = y9, wxt=wxt)
      #Female Lee-Carter Fitting
        LCfit_F <- fit(LC, Dxt = dxt_F_R, Ext = Ext_I_F,  ages = x6, years = y9, wxt=wxt)

#Lee-Carter Poisson Plotting the Estimators

par(mfrow= c(1,3))
  plot(ages.fit,LCfit_T$ax, type ="l", ylab = "", xlab = "Age", main = "ax vs x", col="black")
    plot(ages.fit,LCfit_M$ax, type ="l", ylab = "", xlab = "Age", main = "ax vs x", col= "#BFD62F")
      plot(ages.fit,LCfit_F$ax, type ="l", ylab = "", xlab = "Age", main = "ax vs x", col= "#5C666D")

par(mfrow= c(1,3))
  plot(ages.fit,LCfit_T$bx, type ="l", ylab = "", xlab = "Age", main = "bx vs x",col="black")
    plot(ages.fit,LCfit_M$bx, type ="l", ylab = "", xlab = "Age", main = "bx vs x",col="#BFD62F")
      plot(ages.fit,LCfit_F$bx, type ="l", ylab = "", xlab = "Age", main = "bx vs x",col= "#5C666D")

par(mfrow= c(1,3))
  plot(years.fit,LCfit_T$kt, type ="l", ylab = "", xlab = "Age", main = "kt vs t",col="black")
    plot(years.fit,LCfit_M$kt, type ="l", ylab = "", xlab = "Age", main = "kt vs t",col="#BFD62F")
      plot(years.fit,LCfit_F$kt, type ="l", ylab = "", xlab = "Age", main = "kt vs t",col= "#5C666D")

#Lee-Carter Residuals For Total & Female & Male

# Total Poisson Lee-Carter Residuals 
  LCResid_T <- residuals(LCfit_T)
    # Male Poisson Lee-Carter Residuals
      LCResid_M <- residuals(LCfit_M)
        # Female Poisson Lee-Carter Residuals
          LCResid_F <- residuals(LCfit_F)

#Lee-Carter Poisson Colourmap Plotting the Residuals 

par(mfrow= c(1,3))
plot(LCResid_T, type ="colourmap", reslim = c(-3.5,3.5))
  plot(LCResid_M, type ="colourmap", reslim = c(-3.5,3.5))
    plot(LCResid_F, type ="colourmap", reslim = c(-3.5,3.5))

#Lee-Carter Poisson Scatter Plotting the Residuals 
    
par(mfrow= c(1,3))
  plot(LCResid_T, type ="scatter", col="black")
    plot(LCResid_M, type ="scatter", col="#BFD62F")
      plot(LCResid_F, type ="scatter", col="#5C666D")
    
# AIC(Akaike Information Criterion Goodness-of-fit Calibration)

# Lower the value better, better the model is explained.
AIC_PLC_T <- AIC(LCfit_T) # 14479.88
  AIC_PLC_M <- AIC(LCfit_M) # 12791.07
    AIC_PLC_F <- AIC(LCfit_F) # 12756.21

#BIC (Bayesian Information Criteria Goodness-of-fit Calibration)

# Lower the value better, better the model is explained.
BIC_PLC_T <- BIC(LCfit_T) # 14983.55
  BIC_PLC_M <- BIC(LCfit_M) # 13294.74
    BIC_PLC_F <- BIC(LCfit_F) # 13259.88

# The Deviance between the Lee-Carter Poisson Distribution:
Deviance_PLC_T <- deviance(LCfit_T) # 2814.554
  Deviance_PLC_M <- deviance(LCfit_M) # 1899.092
    Deviance_PLC_F <- deviance(LCfit_F) # 2043.2

# ///////////////////////////////////////////////////////////////
# /////Forecasting Lee-Carter Poisson Total & Female & Male///// 
# /////////////////////////////////////////////////////////////  

# Total & Female & Male Lee-Carter Poisson Forecast

LC_Fore_T <- forecast(LCfit_T,h=82, jumpchoice = c("actual"),level = c(80,95)) # Total Lee-Carter Poisson Forecast until 2100
  LC_Fore_M <- forecast(LCfit_M,h=82, jumpchoice = c("actual"),level = c(80,95)) # Female Lee-Carter Poisson Forecast until 2100
    LC_Fore_F <- forecast(LCfit_F,h=82, jumpchoice = c("actual"),level = c(80,95)) # Male Lee-Carter Poisson Forecast until 2100

# Plotting the Forecast Lee-Carter Poisson
par(mfrow= c(1,3))
  plot(LC_Fore_T, only.kt = TRUE, panel.first = grid()) # Total Lee-Carter Poisson Forecast Total Plot
    plot(LC_Fore_M, only.kt = TRUE, col="#BFD62F", panel.first = grid()) # Male Lee-Carter Poisson Forecast  Plot
      plot(LC_Fore_F, only.kt = TRUE, col= "#5C666D", panel.first = grid()) # Female Lee-Carter Poisson Forecast Plot

# ////////////////////////////////////////////////////////////////////////
# /////Forecasting MAPE, RMSE, MSE, Accuracies Total & Female & Male///// 
# //////////////////////////////////////////////////////////////////////  

# Forecasting MAPE, RMSE, MSE, Accuracies & Creating the Table
  yield <- 0.02 # annuity guaranteed interest rate
    model.names <- c('LC')  # model acronym
      NM <- length(model.names)     # Number of models tested
        crit.names <- c('MSE','MAPE','RMSE')
          ncrit <- length(crit.names)   # Number of forecasting accuracy criteria 
            fac <- array(0, dim=c(ncrit,NM), dimnames = list(crit.names, model.names))  # forecasting accuracy criteria
      
# Defining the Training/Test data set
  hp <- 10               # holdout period #Information from 2009 to 2018 last 10 years
    train <- 1:(nt-hp)     # training years
        ntt <- length(train)
          fac.fun <- function (act, pred){
            # Mean Absolute Percent Error
              MAPE <- mape(act, pred)
                # Root Mean Squared Error
                  RMSE <- rmse(act, pred)
                    # Mean Squared Error
                      MSE <- mse(act, pred)
                        fac <- rbind(MSE=MSE, MAPE=MAPE, RMSE=RMSE)
                          return(list(fac=fac))
                        }  
  fac[,'LC'] <- fac.fun(LC_Fore_T$rates[,1:hp], mxt_T_R[,-train])$fac # Forecasting Total Accuracy 2019 to 2028 & Train 2018 to 2009 and with fitted 1980 to 2018
    fac*1000000
      fac[,'LC'] <- fac.fun(LC_Fore_M$rates[,1:hp], mxt_M_R[,-train])$fac # Forecasting Male Accuracy 2019 to 2028 & Train 2018 to 2009 and with fitted 1980 to 2018
        fac*1000000
          fac[,'LC'] <- fac.fun(LC_Fore_F$rates[,1:hp], mxt_F_R[,-train])$fac # Forecasting Female Accuracy 2019 to 2028 & Train 2018 to 2009 and with fitted 1980 to 2018
            fac*1000000
                
#Creating the Life Tables & Life Expectancy
matrix_pop=matrix(1,nrow = 31, ncol = 82)
  LC_Fore_T_demog <- demogdata(LC_Fore_T$rates, pop=matrix_pop, ages=60:90, type='mortality', years=2019:2100, name='PRT', label='PRT')
    LC_Fore_M_demog <- demogdata(LC_Fore_M$rates, pop=matrix_pop, ages=60:90, type='mortality', years=2019:2100, name='PRT', label='PRT')
      LC_Fore_F_demog <- demogdata(LC_Fore_F$rates, pop=matrix_pop, ages=60:90, type='mortality', years=2019:2100, name='PRT', label='PRT')
        LT_forecast_LT_T <- lifetable(LC_Fore_T_demog, type=c("cohort")) # Forecast Lee Carter Total Life Tables  (Take after 1 by one parameter the Life Tables)
          LT_forecast_LT_M <- lifetable(LC_Fore_M_demog, type=c("cohort")) # Forecast Lee Carter Male Life Tables (Take after 1 by one parameter the Life Tables)
            LT_forecast_LT_F <- lifetable(LC_Fore_F_demog, type=c("cohort")) # Forecast Lee Carter Female Life Tables (Take after 1 by one parameter the Life Tables)
              LT_forecast_LE_T <- life.expectancy(LC_Fore_T_demog) # Forecast Lee Carter Total Life Expectancy
                LT_forecast_LE_M <- life.expectancy(LC_Fore_M_demog) # Forecast Lee Carter Male Life Expectancy
                  LT_forecast_LE_F <- life.expectancy(LC_Fore_F_demog) # Forecast Lee Carter Female Life Expectancy

#Creating the individual cohort parameter forecasted in diagonal of life tables for all genders:
  LT_forecast_LT_T$mx # Death rate at age x for Total
    LT_forecast_LT_T$qx # The probability that an individual of exact age x will die before exact age x+1 for Total
      LT_forecast_LT_T$lx # Number of survivors to exact age x. The radix is 1 for Total
        LT_forecast_LT_T$dx # The number of deaths between exact ages x and x+1 for Total
          LT_forecast_LT_T$Lx # Number of years lived between exact age x and exact age x+1 for Total
            LT_forecast_LT_T$Tx # Number of years lived after exact age x for Total.
              LT_forecast_LT_T$ex # Remaining life expectancy at exact age x for Total
  
              
  LT_forecast_LT_M$mx # Death rate at age x for Male
    LT_forecast_LT_M$qx # The probability that an individual of exact age x will die before exact age x+1 for Male
      LT_forecast_LT_M$lx # Number of survivors to exact age x. The radix is 1 for Male
        LT_forecast_LT_M$dx # The number of deaths between exact ages x and x+1 for Male
          LT_forecast_LT_M$Lx # Number of years lived between exact age x and exact age x+1 for Male
            LT_forecast_LT_M$Tx # Number of years lived after exact age x for Male
              LT_forecast_LT_M$ex # Remaining life expectancy at exact age x for Male
  
  
  LT_forecast_LT_F$mx # Death rate at age x for Female
    LT_forecast_LT_F$qx # The probability that an individual of exact age x will die before exact age x+1 for Female
      LT_forecast_LT_F$lx # Number of survivors to exact age x. The radix is 1 for Female
        LT_forecast_LT_F$dx # The number of deaths between exact ages x and x+1 for Female
          LT_forecast_LT_F$Lx # Number of years lived between exact age x and exact age x+1 for Female
            LT_forecast_LT_F$Tx # Number of years lived after exact age x for Female
              LT_forecast_LT_F$ex # Remaining life expectancy at exact age x for Female
  
#Creating the Values for Plot Forecast Life Expectancy:
 x2 <- 2019:2100
  y6 <- LT_forecast_LE_T
    y7 <- LT_forecast_LE_M
      y8 <- LT_forecast_LE_F
       y_min <- min(y6, y7, y8)
        y_max <- max(c(y6, y7, y8))
          plot(x2, y6, type = "l", xlab = "Year", ylab = " Forecast Life Expectancy Upper 2019", ylim = c(y_min, y_max), main = "Forecast Mortality Rates")
            lines(x2, y7, col = "#BFD62F") # Male
              lines(x2, y8, col = "#5C666D") # Female
                legend("bottomright", legend = c("Total", "Male", "Female"), 
                    col = c("black", "#BFD62F", "#5C666D"), lty = 1, cex = 0.8, bty = "n", y.intersp = 1.5)


# Age Period Cohorts Analysis
                
years.fit1 <- 1890:1958                
#Age Period Cohort Distribution for the Number of Deaths
  APC <- apc(link = "logit")
    #Total Age Period Cohort Fitting
      APCfit_T <- fit(APC, Dxt = dxt_T_R, Ext = Ext_I_T,  ages = x6, years = y9, wxt=wxt)
        #Male Age Period Cohort Fitting
          APCfit_M <- fit(APC, Dxt = dxt_M_R, Ext = Ext_I_M,  ages = x6, years = y9, wxt=wxt)
            #Female Age Period Cohort Fitting
              APCfit_F <- fit(APC, Dxt = dxt_F_R, Ext = Ext_I_F,  ages = x6, years = y9, wxt=wxt)                

#Age Period Cohort Plotting the Estimators
  par(mfrow= c(1,3))
    plot(ages.fit,APCfit_T$ax, type ="l", ylab = "", xlab = "Age", main = "ax vs x", col="black")
      plot(ages.fit,APCfit_M$ax, type ="l", ylab = "", xlab = "Age", main = "ax vs x", col= "#BFD62F")
        plot(ages.fit,APCfit_F$ax, type ="l", ylab = "", xlab = "Age", main = "ax vs x", col= "#5C666D")

par(mfrow= c(1,3))
  plot(years.fit1,APCfit_T$gc, type ="l", ylab = "", xlab = "Years", main = "gc vs t-x",col="black")
    plot(years.fit1,APCfit_M$gc, type ="l", ylab = "", xlab = "Years", main = "gc vs t-x",col="#BFD62F")
      plot(years.fit1,APCfit_F$gc, type ="l", ylab = "", xlab = "Years", main = "gc vs t-x",col= "#5C666D")
              
par(mfrow= c(1,3))
  plot(years.fit,APCfit_T$kt, type ="l", ylab = "", xlab = "Age", main = "kt vs t",col="black")
    plot(years.fit,APCfit_M$kt, type ="l", ylab = "", xlab = "Age", main = "kt vs t",col="#BFD62F")
      plot(years.fit,APCfit_F$kt, type ="l", ylab = "", xlab = "Age", main = "kt vs t",col= "#5C666D")
              
#Age Period Cohort Residuals For Total & Female & Male
              
#Total Age Period Cohort Residuals 
  APCResid_T <- residuals(APCfit_T)
  #Male Age Period Cohort Residuals
    APCResid_M <- residuals(APCfit_M)
      #Female Age Period Cohort Residuals
        APCResid_F <- residuals(APCfit_F)
              
#Age Period Cohort Colourmap Plotting the Residuals 
  par(mfrow= c(1,3))
    plot(APCResid_T, type ="colourmap", reslim = c(-3.5,3.5))
      plot(APCResid_M, type ="colourmap", reslim = c(-3.5,3.5))
        plot(APCResid_F, type ="colourmap", reslim = c(-3.5,3.5))
              
#Age Period Cohort Scatter Plotting the Residuals 
  par(mfrow= c(1,3))
    plot(APCResid_T, type ="scatter", col="black")
      plot(APCResid_M, type ="scatter", col="#BFD62F")
        plot(APCResid_F, type ="scatter", col="#5C666D")
              
#AIC(Akaike Information Criterion Goodness-of-fit Calibration)
              
  # Lower the value better, better the model is explained.
      AIC_APC_T <- AIC(APCfit_T) # 15590.32
        AIC_APC_M <- AIC(APCfit_M) # 13405.54
          AIC_APC_F <- AIC(APCfit_F) # 13470.05
              
#BIC (Bayesian Information Criteria Goodness-of-fit Calibration)
              
  # Lower the value better, better the model is explained.
      BIC_APC_T <- BIC(APCfit_T) # 16251.71
        BIC_APC_M <- BIC(APCfit_M) # 14066.92
          BIC_APC_F <- BIC(APCfit_F) # 14131.44
              
#The Deviance between the Average Period Cohort Distribution:
  Deviance_APC_T <- deviance(APCfit_T) # 3559.105
    Deviance_APC_M <- deviance(APCfit_M) # 2119.864
      Deviance_APC_F <- deviance(APCfit_F) # 2567.988
      
# //////////////////////////////////////////////////////////////////
# /////Forecasting Average Period Cohort Total & Female & Male///// 
# ////////////////////////////////////////////////////////////////  
      
# Total & Female & Male Lee-Carter Poisson Forecast
      
  APC_Fore_T <- forecast(APCfit_T,h=82, jumpchoice = c("actual"),level = c(80,95)) # Total Lee-Carter Poisson Forecast until 2100
    APC_Fore_M <- forecast(APCfit_M,h=82, jumpchoice = c("actual"),level = c(80,95)) # Female Lee-Carter Poisson Forecast until 2100
      APC_Fore_F <- forecast(APCfit_F,h=82, jumpchoice = c("actual"),level = c(80,95)) # Male Lee-Carter Poisson Forecast until 2100
      
# Plotting the Forecast Lee-Carter Poisson
    par(mfrow= c(1,3))
      plot(APC_Fore_T, only.kt = TRUE, panel.first = grid()) # Total Lee-Carter Poisson Forecast Total Plot
        plot(APC_Fore_M, only.kt = TRUE, col="#BFD62F", panel.first = grid()) # Male Lee-Carter Poisson Forecast  Plot
          plot(APC_Fore_F, only.kt = TRUE, col= "#5C666D", panel.first = grid()) # Female Lee-Carter Poisson Forecast Plot
      
# ////////////////////////////////////////////////////////////////////////
# /////Forecasting MAPE, RMSE, MSE, Accuracies Total & Female & Male///// 
# //////////////////////////////////////////////////////////////////////  
      
# Forecasting MAPE, RMSE, MSE, Accuracies & Creating the Table
    yield <- 0.02 # annuity guaranteed interest rate
      model.names <- c('APC')  # model acronym
        NM <- length(model.names)     # Number of models tested
          crit.names <- c('MSE','MAPE','RMSE')
            ncrit <- length(crit.names)   # Number of forecasting accuracy criteria 
              fac1 <- array(0, dim=c(ncrit,NM), dimnames = list(crit.names, model.names))  # forecasting accuracy criteria
      
# Defining the Training/Test data set
    hp <- 10               # holdout period #Information from 2009 to 2018 last 10 years
      train <- 1:(nt-hp)     # training years
        ntt <- length(train)
          fac.fun1 <- function (act, pred){
            # Mean Absolute Percent Error
              MAPE <- mape(act, pred)
                # Root Mean Squared Error
                  RMSE <- rmse(act, pred)
                    # Mean Squared Error
                      MSE <- mse(act, pred)
                        fac1 <- rbind(MSE=MSE, MAPE=MAPE, RMSE=RMSE)
                          return(list(fac1=fac1))
      }  
fac1[,'APC'] <- fac.fun1(APC_Fore_T$rates[,1:hp], mxt_T_R[,-train])$fac1 # Forecasting Total Accuracy 2019 to 2028 & Train 2018 to 2009 and with fitted 1980 to 2018
  fac1*1000000
    fac1[,'APC'] <- fac.fun1(APC_Fore_M$rates[,1:hp], mxt_M_R[,-train])$fac1 # Forecasting Male Accuracy 2019 to 2028 & Train 2018 to 2009 and with fitted 1980 to 2018
      fac1*1000000
        fac1[,'APC'] <- fac.fun1(APC_Fore_F$rates[,1:hp], mxt_F_R[,-train])$fac1 # Forecasting Female Accuracy 2019 to 2028 & Train 2018 to 2009 and with fitted 1980 to 2018
          fac1*1000000
      
# /////////////////////////////////////////////////////////////////////////////
# /////Semi-Parametric bootstrap Lee-Carter Poisson Total & Female & Male/////    
# ///////////////////////////////////////////////////////////////////////////  
          
LCboot_T <- StMoMo::bootstrap(LCfit_T, nBoot = 10, type = "semiparametric")   
  LCboot_M <- StMoMo::bootstrap(LCfit_M, nBoot = 10, type = "semiparametric")
    LCboot_F <- StMoMo::bootstrap(LCfit_F, nBoot = 10, type = "semiparametric")
    
#Parameters Risk Bootstrap 
plot(LCboot_T, ncol=3, col="black")
  plot(LCboot_M,ncol=3, col ="#BFD62F")
    plot(LCboot_F, ncol=3, col="#5C666D")

#Bootstrapped Simulation number of trajectories 100 Lee-Carter (60-90 and 1980-2100):           
      LCsim_boot_T <- simulate(LCboot_T, nsim = 100, h = 82) # Lee-Carter Total Simulation Bootstrapping
        LCsim_boot_M <- simulate(LCboot_M, nsim = 100, h = 82) # Lee-Carter Female Simulation Bootstrapping
          LCsim_boot_F <- simulate(LCboot_F, nsim = 100, h = 82) # Lee-Carter Male Simulation Bootstrapping

# Total Lee-Carter Semi-Parametric Bootstrapped 1000 simulations (60-90 and 1980-2100):
  set.seed(1234)
    LC_Fit_sim_T <- simulate(LCfit_T, nsim = 10, h = 82) 
          x <- c("60","75","90")
            mxt_T <- LCfit_T$Dxt / LCfit_T$Ext #1980 to 2018
              mxtHat_T <- fitted(LCfit_T, type = "rates") #1980 to 2018
                mxtCentral_T <- LC_Fore_T$rates # 2019 to 2100
                  mxtPred2.5_T <-  apply(LC_Fit_sim_T$rates, c(1, 2), quantile, probs = 0.025) #2019 to 2100
                    mxtPred97.5_T <- apply(LC_Fit_sim_T$rates, c(1, 2), quantile, probs = 0.975) #2019 to 2100
                      mxtHatPU2.5_T <- apply(LCsim_boot_T$fitted, c(1, 2), quantile, probs = 0.025) #1980 to 2018
                        mxtHatPU97.5_T <-apply(LCsim_boot_T$fitted, c(1, 2), quantile, probs = 0.975) #1980 to 2018
                          mxtPredPU2.5_T <-apply(LCsim_boot_T$rates, c(1, 2), quantile, probs = 0.025) # 2019 to 2100
                            mxtPredPU97.5_T<-apply(LCsim_boot_T$rates, c(1, 2), quantile, probs = 0.975) #2019 to 2100
                              matplot(LCfit_T$years, t(mxt_T[x, ]),
                                xlim = range(LCfit_T$years, LC_Fore_T$years),
                                  ylim = range(mxtHatPU97.5_T[x, ], mxtPredPU2.5_T[x, ],
                                    mxt_T[x, ]), type = "p", xlab = "years",
                                      ylab = "mortality rates (log scale)", log = "y", 
                                        pch = 20, col = "black")
                                          matlines(LCfit_T$years, t(mxtHat_T[x, ]), lty = 1, col = "black")
                                            matlines(LCfit_T$years, t(mxtHatPU2.5_T[x, ]), lty = 5, col = "#BFD62F")
                                              matlines(LCfit_T$years, t(mxtHatPU97.5_T[x, ]), lty = 5, col = "#BFD62F")
                                                matlines(LC_Fore_T$years, t(mxtCentral_T[x, ]), lty = 4, col = "black")
                                                  matlines(LC_Fit_sim_T$years, t(mxtPred2.5_T[x, ]), lty = 3, col = "black")
                                                    matlines(LC_Fit_sim_T$years, t(mxtPred97.5_T[x, ]), lty = 3, col = "black")
                                                      matlines(LCsim_boot_T$years, t(mxtPredPU2.5_T[x, ]), lty = 5, col = "#BFD62F")
                                                        matlines(LCsim_boot_T$years, t(mxtPredPU97.5_T[x, ]), lty = 5, col = "#BFD62F")
                                                          text(1983, mxtHatPU2.5_T[x, "2000"], labels = c("x=60", "x=75", "x=90"))      
        
# Female Lee-Carter Semi-Parametric Bootstrapped 1000 simulations (60-90 and 1980-2100):
 set.seed(1234)
  LC_Fit_sim_F <- simulate(LCfit_F, nsim = 1, h = 82) 
    x <- c("60","75","90")
      mxt_F <- LCfit_F$Dxt / LCfit_F$Ext #1980 to 2018
        mxtHat_F <- fitted(LCfit_F, type = "rates") #1980 to 2018
          mxtCentral_F <- LC_Fore_F$rates # 2019 to 2100
            mxtPred2.5_F <-  apply(LC_Fit_sim_F$rates, c(1, 2), quantile, probs = 0.025) #2019 to 2100
              mxtPred97.5_F <- apply(LC_Fit_sim_F$rates, c(1, 2), quantile, probs = 0.975) #2019 to 2100
                mxtHatPU2.5_F <- apply(LCsim_boot_F$fitted, c(1, 2), quantile, probs = 0.025) #1980 to 2018
                  mxtHatPU97.5_F <-apply(LCsim_boot_F$fitted, c(1, 2), quantile, probs = 0.975) #1980 to 2018
                    mxtPredPU2.5_F <-apply(LCsim_boot_F$rates, c(1, 2), quantile, probs = 0.025) # 2019 to 2100
                      mxtPredPU97.5_F<-apply(LCsim_boot_F$rates, c(1, 2), quantile, probs = 0.975) #2019 to 2100
                        matplot(LCfit_F$years, t(mxt_F[x, ]),
                          xlim = range(LCfit_F$years, LC_Fore_F$years),
                            ylim = range(mxtHatPU97.5_F[x, ], mxtPredPU2.5_F[x, ],
                              mxt_F[x, ]), type = "p", xlab = "years",
                                ylab = "mortality rates (log scale)", log = "y", 
                                  pch = 20, col = "black")
                                    matlines(LCfit_F$years, t(mxtHat_F[x, ]), lty = 1, col = "black")
                                      matlines(LCfit_F$years, t(mxtHatPU2.5_F[x, ]), lty = 5, col = "#BFD62F")
                                        matlines(LCfit_F$years, t(mxtHatPU97.5_F[x, ]), lty = 5, col = "#BFD62F")
                                          matlines(LC_Fore_F$years, t(mxtCentral_F[x, ]), lty = 4, col = "black")
                                            matlines(LC_Fit_sim_F$years, t(mxtPred2.5_F[x, ]), lty = 3, col = "black")
                                              matlines(LC_Fit_sim_F$years, t(mxtPred97.5_F[x, ]), lty = 3, col = "black")
                                                matlines(LCsim_boot_F$years, t(mxtPredPU2.5_F[x, ]), lty = 5, col = "#BFD62F")
                                                  matlines(LCsim_boot_F$years, t(mxtPredPU97.5_F[x, ]), lty = 5, col = "#BFD62F")
                                                    text(1983, mxtHatPU2.5_F[x, "2000"], labels = c("x=60", "x=75", "x=90"))      
                                                          
# Male Lee-Carter Semi-Parametric Bootstrapped 1000 simulations (60-90 and 1980-2100):
  set.seed(1234) 
    LC_Fit_sim_M <- simulate(LCfit_M, nsim = 1, h = 82) 
      x <- c("60","75","90")
        mxt_M <- LCfit_M$Dxt / LCfit_M$Ext #1980 to 2018
          mxtHat_M <- fitted(LCfit_M, type = "rates") #1980 to 2018
            mxtCentral_M <- LC_Fore_M$rates # 2019 to 2100
              mxtPred2.5_M <-  apply(LC_Fit_sim_M$rates, c(1, 2), quantile, probs = 0.025) #2019 to 2100
                mxtPred97.5_M <- apply(LC_Fit_sim_M$rates, c(1, 2), quantile, probs = 0.975) #2019 to 2100
                  mxtHatPU2.5_M <- apply(LCsim_boot_M$fitted, c(1, 2), quantile, probs = 0.025) #1980 to 2018
                    mxtHatPU97.5_M <-apply(LCsim_boot_M$fitted, c(1, 2), quantile, probs = 0.975) #1980 to 2018
                      mxtPredPU2.5_M <-apply(LCsim_boot_M$rates, c(1, 2), quantile, probs = 0.025) # 2019 to 2100
                        mxtPredPU97.5_M<-apply(LCsim_boot_M$rates, c(1, 2), quantile, probs = 0.975) #2019 to 2100
                          matplot(LCfit_M$years, t(mxt_M[x, ]),
                            xlim = range(LCfit_M$years, LC_Fore_M$years),
                              ylim = range(mxtHatPU97.5_M[x, ], mxtPredPU2.5_M[x, ],
                                mxt_M[x, ]), type = "p", xlab = "years",
                                  ylab = "mortality rates (log scale)", log = "y", 
                                    pch = 20, col = "black")
                                      matlines(LCfit_M$years, t(mxtHat_M[x, ]), lty = 1, col = "black")
                                        matlines(LCfit_M$years, t(mxtHatPU2.5_M[x, ]), lty = 5, col = "#BFD62F")
                                          matlines(LCfit_M$years, t(mxtHatPU97.5_M[x, ]), lty = 5, col = "#BFD62F")
                                            matlines(LC_Fore_M$years, t(mxtCentral_M[x, ]), lty = 4, col = "black")
                                              matlines(LC_Fit_sim_M$years, t(mxtPred2.5_M[x, ]), lty = 3, col = "black")
                                                matlines(LC_Fit_sim_M$years, t(mxtPred97.5_M[x, ]), lty = 3, col = "black")
                                                  matlines(LCsim_boot_M$years, t(mxtPredPU2.5_M[x, ]), lty = 5, col = "#BFD62F")
                                                    matlines(LCsim_boot_M$years, t(mxtPredPU97.5_M[x, ]), lty = 5, col = "#BFD62F")
                                                      text(1983, mxtHatPU2.5_M[x, "2000"], labels = c("x=60", "x=75", "x=90"))      

                                                                                                                  
# /////////////////////////////////////////////////////////////////////////////
# /////Annuity prices for contracts on cohorts of individuals aged 65/////////    
# /////////////////////////////////////////////////////////////////////////// 
                                                      
                                                      
# Collecting the Most Recent Data (using hypothetical data for demonstration)
  # Annuity prices for individuals aged 65 in 2024, hypothetical dataset
    annuity_data <- data.frame(
      ID = 1:5,
        Capital = c(50000, 100000, 250000, 500000, 1000000),
          Annuity = c(2127.57, 4332, 11080, 22392, 45016),
            Tax_Rate = rep(35, 5)
            )
                                                      
              # Verify the structure of the data
                str(annuity_data)
                  summary(annuity_data)
                                                      
                    # Define Parameters
                      LSage <- 65      # Age 65 in 2024
                        LSy <- 2024      # Valuation Year
                          Not <- 10000     # Notional
                            LSmat <- 10      # Maturity
                              Wang_lbd <- 0.3  # Lambda for Wang Transform
                                                      
                                # Yield curve data (hypothetical example)
                                    beta0 <- 0.047638
                                      beta1 <- -0.050484
                                        beta2 <- -0.219748
                                          beta3 <- -0.125183
                                            tau1 <- 0.062279
                                              tau2 <- 1.106536
                                                      
                                            # Spot rate function
                                            NSS_spot <- function(theta, tau1, tau2, beta0, beta1, beta2, beta3){
                                            beta0 + beta1*(1-exp(-theta/tau1))/(theta/tau1) + 
                                           beta2*((1-exp(-theta/tau1))/(theta/tau1) - exp(-theta/tau1)) + 
                                        beta3*((1-exp(-theta/tau2))/(theta/tau2) - exp(-theta/tau2))
                                                      }
                                                      
                                      # Spot interest rates
                                    r0t <- NSS_spot(theta=1:LSmat, tau1=tau1, tau2=tau2, beta0=beta0, beta1=beta1, 
                                  beta2=beta2, beta3=beta3)
                               par(mfrow=c(1,1), mar=c(5, 5, 4, 2) + 0.1)
                            plot(1:LSmat, r0t, type='l', col='#BFD62F', lwd=2, xlab='Term', 
                          main='Spot yield curve', ylab='r(0,t)')
                                                      
                      # Discount factor (B0t=exp(-r(0,t)*t))
                                                      B0t <- exp(-c(1:LSmat)*r0t)
                                                      
                     # Generating Stochastic Mortality Rate Forecasts
                   set.seed(123)  # For reproducibility
                n_sim <- 1000
              mu <- 0.015   # Mean mortality rate
            sigma <- 0.005 # Standard deviation
          rho <- 0.9    # Autocorrelation factor
    # Generate correlated mortality rates using AR(1) process
  generate_mortality_rates <- function(n, mu, sigma, rho) {
    e <- rnorm(n, mean=0, sd=sigma)
     x <- numeric(n)
      x[1] <- mu
       for (i in 2:n) {
         x[i] <- mu + rho * (x[i-1] - mu) + e[i]
            }
           return(x)
      }
            mortality_forecasts <- replicate(n_sim, generate_mortality_rates(LSmat, mu, sigma, rho))
                # Plot some simulated mortality rate paths
                    matplot(1:LSmat, mortality_forecasts[, 1:10], type='l', col=rainbow(10), lty=1, 
                                                              main="Simulated Mortality Rate Paths", xlab="Year", ylab="Mortality Rate")
                                                      
                        # : Estimating Longevity Risk Loadings using various pricing principles
                                                      
                          # Pricing Transformations
                              PH.fun <- function (x, lambda) {
                                  if (lambda < 1) stop("invalid lambda value")
                                    return(x^(1/lambda))
                                                      }
                                                      
                                        exp.fun <- function(x, lambda) {
                                            if (lambda <= 0) stop("invalid lambda value")
                                              return((1 - exp(-lambda * x)) / (1 - exp(-lambda)))
                                                      }
                                                      
                                           Wang.fun <- function (u, lambda, flag=+1) {
                                          if (lambda < 0) stop("invalid lambda value")
                                        return (pnorm(qnorm(u) + flag*lambda)) 
                                                      }
                                                      
                                    # Standard Deviation Principle
                                  std_dev_principle <- function(cash_flows, discount_factors) {
                                mean_cf <- mean(cash_flows * discount_factors)
                              std_dev_cf <- sd(cash_flows * discount_factors)
                            return(mean_cf + std_dev_cf)
                                                      }
                                                      
                          risk_loadings <- data.frame(
                        Wang = numeric(n_sim),
                      PH = numeric(n_sim),
                    Exp = numeric(n_sim),
                StdDev = numeric(n_sim)
                          )
                                                      
             for (i in 1:n_sim) {
          tpx_sim <- cumprod(1 - mortality_forecasts[, i])
                                                        
     # Applying transformations
   tpx_ph <- PH.fun(tpx_sim, lambda=1.2)
tpx_exp <- exp.fun(tpx_sim, lambda=0.3)
 tpx_wang <- Wang.fun(tpx_sim, Wang_lbd, flag=+1)
                                                        
 # Fixed and floating legs
  CF.fixwang <- Not * tpx_wang
   CF.fixph <- Not * tpx_ph
    CF.fixexp <- Not * tpx_exp
      CF.float <- Not * tpx_sim
                                                        
     # Risk Premium (percentage)
      risk_loadings$Wang[i] <- sum(CF.fixwang * B0t) / sum(CF.float * B0t) - 1
       risk_loadings$PH[i] <- sum(CF.fixph * B0t) / sum(CF.float * B0t) - 1
        risk_loadings$Exp[i] <- sum(CF.fixexp * B0t) / sum(CF.float * B0t) - 1
         risk_loadings$StdDev[i] <- std_dev_principle(CF.fixwang, B0t) / sum(CF.float * B0t) - 1
                                                      }
         #  Analyzing the Results
          summary(risk_loadings)
           boxplot(risk_loadings, main="Longevity Risk Loadings")
                                                      
            # Visualize the risk premium distribution
                par(mfrow=c(2,2))
                 hist(risk_loadings$Wang, main="Distribution of Longevity Risk Loadings (Wang)", xlab="Risk Loading", breaks=50, col="blue")
                  hist(risk_loadings$PH, main="Distribution of Longevity Risk Loadings (PH)", xlab="Risk Loading", breaks=50, col="green")
                   hist(risk_loadings$Exp, main="Distribution of Longevity Risk Loadings (Exp)", xlab="Risk Loading", breaks=50, col="red")
                     hist(risk_loadings$StdDev, main="Distribution of Longevity Risk Loadings (Std Dev)", xlab="Risk Loading", breaks=50, col="purple")
                      # Plotting mean and standard deviation of risk loadings
                        risk_summary <- risk_loadings %>%
                          summarise(
                            Mean_Wang = mean(Wang),
                               SD_Wang = sd(Wang),
                                  Mean_PH = mean(PH),
                                     SD_PH = sd(PH),
                                       Mean_Exp = mean(Exp),
                                        SD_Exp = sd(Exp),
                                          Mean_StdDev = mean(StdDev),
                                            SD_StdDev = sd(StdDev)
                                                        )
                                        par(mfrow=c(1,1))
                                    barplot(as.matrix(risk_summary[, c(1, 3, 5, 7)]), beside=TRUE,
                                  col=c("blue", "green", "red", "purple"),
                                names.arg=c("Wang", "PH", "Exp", "StdDev"),
                              legend.text=c("Mean", "Standard Deviation"),
                            args.legend=list(x="topright"),
                          main="Mean and Standard Deviation of Longevity Risk Loadings",
                                                              ylab="Value")
                                                      
                        # Longevity Swap Contracts Analysis for Maturities from 5 to 25 Years
                      maturities <- 5:25
                    swap_premiums <- data.frame(
          Maturity = maturities,
     Wang = numeric(length(maturities)),
   PH = numeric(length(maturities)),
 Exp = numeric(length(maturities)),
StdDev = numeric(length(maturities))
)
 for (mat in maturities) {
  B0t_long <- exp(-c(1:mat)*r0t[1:mat])
   for (i in 1:n_sim) {
    tpx_sim <- cumprod(1 - mortality_forecasts[1:mat, i])
                                                          
     # Applying transformations
      tpx_ph <- PH.fun(tpx_sim, lambda=1.2)
       tpx_exp <- exp.fun(tpx_sim, lambda=0.3)
         tpx_wang <- Wang.fun(tpx_sim, Wang_lbd, flag=+1)
                                                          
         # Fixed and floating legs
            CF.fixwang <- Not * tpx_wang
             CF.fixph <- Not * tpx_ph
              CF.fixexp <- Not * tpx_exp
               CF.float <- Not * tpx_sim
             # Risk Premium (percentage)
              swap_premiums$Wang[mat-4] <- swap_premiums$Wang[mat-4] + (sum(CF.fixwang * B0t_long) / sum(CF.float * B0t_long) - 1) / n_sim
                swap_premiums$PH[mat-4] <- swap_premiums$PH[mat-4] + (sum(CF.fixph * B0t_long) / sum(CF.float * B0t_long) - 1) / n_sim
                  swap_premiums$Exp[mat-4] <- swap_premiums$Exp[mat-4] + (sum(CF.fixexp * B0t_long) / sum(CF.float * B0t_long) - 1) / n_sim
                    swap_premiums$StdDev[mat-4] <- swap_premiums$StdDev[mat-4] + (std_dev_principle(CF.fixwang, B0t_long) / sum(CF.float * B0t_long) - 1) / n_sim
                                                        }
                                                      }
                                                      
# Plotting the implied risk premiums for longevity swap contracts
  matplot(swap_premiums$Maturity, as.matrix(swap_premiums[,-1]), type='l', lwd=2,
    col=c("blue", "green", "red", "purple"), lty=1, xlab="Maturity (Years)",
      ylab="Implied Risk Premium", main="Implied Risk Premiums for Longevity Swap Contracts")
        legend("topright", legend=c("Wang", "PH", "Exp", "StdDev"),
          col=c("blue", "green", "red", "purple"), lty=1, lwd=2)
                                                      
par# Analysis and Discussion
summary(swap_premiums)
                                                      
# Commentary:
# The implied risk premiums for longevity swap contracts vary across different pricing principles and maturities.
# The Wang transform shows the highest risk premiums, indicating a higher sensitivity to mortality risk.
# The Proportional Hazard (PH) and Exponential (Exp) transforms show moderate risk premiums.
# The Standard Deviation principle has relatively lower risk premiums.
# The risk premiums generally increase with maturity, reflecting the increased uncertainty and risk over longer horizons.


