
# //////////////////////////////////
# /////Importing & Viewing Data////
# ////////////////////////////////

file_path <- "C:/Users/luiss/Desktop/Europe GDP Project/Europe Gross Domestic Product (GDP) Dataset.csv" # Creating Dataset File Path.
data <- read.csv(file_path) # Importing for Rstudio our Dataset.

#Observe all variables used for our Project:
View(data)

# Check the structure of the loaded data:
str(data)

# //////////////////////////////////
# /////GDP Regressions Attempts////
# ////////////////////////////////

#How GDP in European Countries, is influenced by Immigration, and student enrollment in Education of Total population of Europe.
reg7 <- lm(gdpcountry ~ imigrtot + stdenroleduc, data=data) 
  summary(reg7)

#How GDP in European Countries, is influenced by the Emigration, and student enrollment in Education of Total population of Europe.
reg8 <- lm(gdpcountry ~ stdenroleduc + emigrtot, data=data) 
  summary(reg8)

#How GDP in European Countries, is influenced by the Emigration and Immigration of Total population of Europe.
  reg9 <- lm(gdpcountry ~ imigrtot + emigrtot, data=data) 
summary(reg9)

#How GDP in European Countries, is influenced by the Emigration, Immigration, and Student and Pupils Enrolled by all Education of Total population. #####TOP REGRESSIONS.
reg10 <- lm(log(gdpcountry) ~ log(imigrtot) + log(emigrtot) + log(stdenroleduc), data=data)
  summary(reg10) # Main Regression of the Project.

# ///////////////////////////////////////////////////////////////////
# /////T-Test for Our Independent Variables in our Main Regression//
# /////////////////////////////////////////////////////////////////
 
# If |tobs | > tα/2 =⇒ reject H0 at the α × 100% level
# If |tobs | ≤ tα/2 =⇒ do not reject H0
  
# t-Test on the variables (Immigration):        
tobsimigrtot <- 1.0560/0.2873 # 3.6756 T-observation.
tobsimigrtot

# t-Test on the variables (Emigration):
emigrtot <- (-0.6847)/0.2448 # -2.796977 T-observation.
emigrtot

# t-Test on the variables (Student Enrollment Education):
stdenroleduc <- 0.6564/ 0.1174 # 5.591141 T-observation.
stdenroleduc

qt(0.95,22) # 1.717144 Critical Value of significance level of 5% with 22 degrees of freedom.
qt(0.90,22) # 1.321237 Critical Value of significance level of 10% with 22 degrees of freedom.

# So, we can conclude that we reject the null hypothesis for all the variables,
# in the significance level of 5% and 10%, meaning that the variables immigration, emigration 
# and the student enrollment on education individually explain the gross domestic product of each country
# in Europe.


# ///////////////////////////////////////////////////////////////////
# /////F-Test for Our Independent Variables in our Main Regression//
# /////////////////////////////////////////////////////////////////

# If Fobs > Fα (or p-value < α) =⇒ Reject H0 
# If Fobs ≤ Fα (or p-value ≥ α) =⇒ Not reject H0

# Lets do the F-Test without the variable stdenroleduc:

# n is the number of observations (26) we have 3 variables and each of them haves 26 rows.
# k is the number of independent variables in the unrestricted model (1)
# q is the number of restrictions (2).

# Unrestricted OLS regression:
  res.ur <- lm(log(gdpcountry) ~ log(imigrtot) + log(emigrtot) + log(stdenroleduc), data=data)
    # Restricted OLS regression:
  res.r <- lm(log(gdpcountry) ~ log(stdenroleduc), data=data)

# R^2 from Unrestricted and Restricted:
(r2.ur <- summary(res.ur)$r.squared ) #0.9262958
(r2.r <- summary(res.r)$r.squared ) #0.8781277

# F-Statistic:
 F <- ((r2.ur-r2.r)/2) / ((1-r2.ur) / (24))
 F # 7.842403
 
 # Calculate the critical value from the F-distribution
 critical_value <- qf(0.95, 1, 24) #Significance level of 5%.
 critical_value #4.259677
 
# So we can conclude that we have statistical significance for the significance
# level of 5%, meaning that the independent variables emigration and emigration
# jointly explain the gross domestic product.


# ///////////////////////////////////////////////////////
# /////Heteroskedasticity Test in our Main Regression///
# /////////////////////////////////////////////////////

  # • Breusch-Pagan Test #1
  # • White (full) Test #2
  # • White (special) Test #3

# ///////////////////////////////
# /////Breusch-Pagan Test #1////
# /////////////////////////////

# H0: Presence Homoscedasticity | H1: Presence Heteroskedasticity

reg10 <- lm(log(gdpcountry) ~ log(imigrtot) + log(emigrtot) + log(stdenroleduc), data=data)
summary(reg10) # Main Regression of the Project.

library(lmtest) # Automatic BP test
  bptest(reg10)
# So, we can conclude that we do not have evidence to suggest the presence of heteroscedasticity in the regression model,
# meaning the variability of the (residuals) errors changes in values across all independent variables change,
# because we will not reject the null hypothesis, because our p-value is higher than significance level of 5%.

summary(lm(resid(reg10)^2 ~ log(imigrtot) + log(emigrtot)+ log(stdenroleduc), data=data)) #Observing the Heteroskedasticity individually.

# We identify that we have presence of heteroskedasticity only in log(imigrtot), and log(stdenroleduc) for significance 
# level of 5%.

# ///////////////////////////////
# /////White (Full) Test #2/////
# /////////////////////////////

# H0: Presence Homoscedasticity | H1: Presence Heteroskedasticity

reg11 <- lm(resid(reg10)^2 ~ log(imigrtot) + log(emigrtot) + log(stdenroleduc) + I(log(imigrtot)^2) + #Ask to professor if it is right, with every variable with log.
            I(log(emigrtot)^2) + I(log(stdenroleduc)^2) + I(log(stdenroleduc) * log(emigrtot)) +
          I(log(stdenroleduc) * log(imigrtot)) + I(log(imigrtot) * log(emigrtot)), data = data)
  summary(reg11) # log(imigrtot) variable that presents heteroscedasticity. from our regression.

#Compute the Linear Model observation:
length(reg10$res)*summary(reg11)$r.squared # 12.93199  # P-value and this value.
  bptest(reg11, data = data) 
# With all variables of White Full Test together, not analysed individually and we can conclude that we do not have presence of
# heteroskedasticity because we do not reject the null hypothesis, because the p-value is higher than the significance level of 5%.
 
 #   /////////////////////
 #  //OR as Alternative//
 # /////////////////////
  
bptest(reg10, ~ log(imigrtot) + log(emigrtot) + log(stdenroleduc) + I(log(imigrtot)^2) + #Ask to professor if it is right, with every variable with log.
         I(log(emigrtot)^2) + I(log(stdenroleduc)^2) + I(log(stdenroleduc) * log(emigrtot)) +
         I(log(stdenroleduc) * log(imigrtot)) + I(log(imigrtot) * log(emigrtot)), data = data)

# With all variables of White Full Test together, not analysed individually and we can conclude that we do not have presence of
# heteroskedasticity because we do not reject the null hypothesis, because the p-value is higher than the significance level of 5%.

# //////////////////////////////////
# /////White (Special) Test #3/////
# ////////////////////////////////

bptest(reg10, ~ fitted(reg10) + I(fitted(reg10)^2))

# With White Special Test,  we can conclude that we do not have presence of heteroskedasticity
# because we do not reject the null hypothesis, because the p-value is higher than the significance level of 5%.

# //////////////////////////////////
# /////Robust Estimation///////////
# ////////////////////////////////

library(lmtest); library(car)
reg10 <- lm(log(gdpcountry) ~ log(imigrtot) + log(emigrtot) + log(stdenroleduc), data=data)
# Usual SE:
coeftest(reg10)
# Refined White heteroscedasticity-robust SE:
coeftest(reg10, vcov=hccm)

# Observing the the final outputs by using the heteroscedasticity of Robust Estimation
# on Standard Errors and the Usual Standard Errors of the coefficients, we can conclude
# that we have statistical significance for both variables log(imigrtot) & log(stdenroleduc)
# meaning that the will not have presence of heteroscedasticity because we reject in both
# scenarios (heteroscedasticity of Robust Estimation) on Standard Errors and the Usual
# Standard Errors) for the significance level of 5%, but for the variable log(emigrtot) we have
# presence of heteroscedasticity because we do not reject in the coefficients of the Standard Error
# for the significance level of 5% but when we apply the Robust Estimation we only reject for
# the significance level of 10%.

# /////////////////////////////////
# /////Chow Test//////////////////  
# ///////////////////////////////

# Expectancy Births Over 80 Years = 1 & Expectancy Births Lower 80 Years = 0
# Country of Europe haves Euro Coin = 1 & Country of Europe does not haves Euro Coin = 0

# Chow Test (What is the partial Effect of having Euro Coins in Immigration, Emigration, and Student Enrollment on Education considering all the countries that have Expectancy births over 80 Years)
reg15 <- lm(log(gdpcountry) ~ eurozone * log(imigrtot) + eurozone * log(emigrtot)+ eurozone * log(stdenroleduc), data=data, subset=(expbirthd==1))
summary(reg15)

#So, we just only use the value of p-value meaning that the explanatory variables explain the gross domestic product of European countries for the significance level of 5%.

# Meaning having the euro coin highly contributes on gross domestic products, the economy growth of Europe Countries according the factors immigration, emigration, and for student enrollment on education.

library(car)
# linearHypothesis(reg15, matchCoefs(reg15, "eurozone"))