####################################################################
####################################################################
# Description: runs the 'DownloadTFXData' function (which downloads the exchange rate data from True FX  for the specified currency pairs, months and years into "out.dir") Saves one csv per combo of pair/month/year.

# Author and date: JOn R, 8/4/17
####################################################################
####################################################################

rm(list = ls()); gc()

pairs = c("AUDJPY", "AUDNZD", "AUDUSD", "CADJPY", 
          "CHFJPY", "EURCHF", "EURGBP", "EURJPY", 
          "EURUSD", "GBPJPY", "GBPUSD", "NZDUSD", 
          "USDCAD", "USDCHF", "USDJPY")
# #***************************
# pairs = c("USDJPY", "EURGBP", "GBPUSD", "NZDUSD", "USDCAD",
#           "USDCAD", "AUDUSD")
# #***************************
months = c("01", "02", "03", "04", "05", "06", 
           "07", "08", "09", "10", "11", "12")
years = c("2014", "2015", "2016", "2017") #can go back farther than this - see website
skip_if_exists = T

base.dir = "C:/Users/Strategy/Desktop/Jonathan/Personal/Trading"
code.dir = file.path(base.dir, "Scripts")
out.dir = file.path(base.dir, "Outputs/DownloadTFXData")
utility_funs = "UtilityFuns_v15_20170801.R"
source(file.path(code.dir, utility_funs))

#Run function. NB loop is in place solely because files dont always download right first time, and there's no overhead to trying again IF skip_if_exists = T (since anything that's downloaded is ignored). And NB if skip_if_exists = F we break out of the loop after the first iteration. 
for (i in 1:5) {
  DownloadTFXData(pairs = pairs, months = months, 
                  years = years, out.dir = out.dir, 
                  skip_if_exists = skip_if_exists)
  if (skip_if_exists == T) {
    break
  }
  gc()
}

