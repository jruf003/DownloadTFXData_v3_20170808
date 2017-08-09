####################################################################
####################################################################
# Description: contains function DownloadTFXData and code to test it (at bottom). this function downloads the exchange rate data for the specified currency pairs, months and years from True FX into "out.dir".

# Author and date: JOn R, 8/4/17
####################################################################
####################################################################

#####################################################################
#             DownloadTFXData FUNCTION
#####################################################################

DownloadTFXData = function(pairs, months, years, out.dir, 
                           skip_if_exists) {
  #Description: downloads the exchange rate data for the specified currency pairs, months and years from True FX into "out.dir". 
  #Args: pairs: a valid currency pair (see 'valid_pairs' for what's valid); months/years: what it sounds like. NB each month must be in e.g. "01", "11" format, out.dir: dir to save in, skip_if_exists: if F, we redownload/extract csv irrespective of whether it already exists. If T, we skip if hte file exists. 
  # REturns: for each combo of pair/month/year, the exchange rate data saved as a zip and csv from True FX.
  
  warning("\n *** IMPORTANT ****\nDON'T THINK THIS CODE WILL RUN UNLESS TRUE FX WEBPAGE IS OPEN AND YOU'RE LOGGED IN\n\n")
  warning("\n *** IMPORTANT ****\nAS PER TFX'S WEBPAGE, ALL TIMES ARE IN GMT. THE TWO COLS ARE BID AND ASK PRICES\n\n")
  library(RCurl) #check if url exists
  
  valid_pairs = c("AUDJPY", "AUDNZD", "AUDUSD", "CADJPY", 
                  "CHFJPY", "EURCHF", "EURGBP", "EURJPY", 
                  "EURUSD", "GBPJPY", "GBPUSD", "NZDUSD", 
                  "USDCAD", "USDCHF", "USDJPY")
  if (!all(pairs %in% valid_pairs)) {
    stop(paste0(pairs[which(!pairs %in% valid_pairs)],
                " is not a valid currency pair"))
  }
  valid_months = c("01", "02", "03", "04", "05", "06", 
                   "07", "08", "09", "10", "11", "12")
  if (!all(months %in% valid_months)) {
    stop ("You havent entred a valid month")
  }
  if (any(as.numeric(years) < 2013)) {
    stop("I've included an error to stop downloading data from before 2013. Prob can back further - just haven't checked whether its available at true fx")
  }
  for (pair in pairs) { #for each pair/month/year, download and unzip the data
    out.dir2 = file.path(out.dir, pair)
    dir.create(out.dir2 , showWarnings = F)
    for (year in years) {
      for (month in months) {
        tryCatch({
          ptm = proc.time()
          
          # Exctract long version of month (needed for url below)
          month2 = switch(month, "01" = "JANUARY", "02" = "FEBRUARY",
                          "03" = "MARCH", "04" = "APRIL", "05" = "MAY",
                          "06" = "JUNE", "07" = "JULY",
                          "08" = "AUGUST", "09" = "SEPTEMBER", 
                          "10" = "OCTOBER", "11" = "NOVEMBER", 
                          "12" = "DECEMBER")
          
          # Download data (if it exists and we havent already )
          datname = paste0(pair, "-", year, "-", month) 
          zip_path = file.path(out.dir2, paste0(datname, ".zip"))
          csv_path = file.path(out.dir2, paste0(datname, ".csv"))
          rdata_path = file.path(out.dir2, paste0(datname, ".RData"))
          cat("Up to ", datname, "\n")
          if (skip_if_exists == T & 
              (paste0(datname, ".RData") %in% list.files(out.dir2))) {
            cat(datname, "wasn't downloaded again as it already exists\n")
            next
          }
          # Two possible versions of the url - we try them both
          url = paste0("http://www.truefx.com/dev/data/",
                       year, "/", month2, "-", year, "/",
                       datname, ".zip")
          url2 = paste0("http://www.truefx.com/dev/data/",
                        year, "/", year, "-", month, "/",
                        datname, ".zip")
          if (url.exists(url)) {
            download.file(url = url, destfile = zip_path) 
            unzip(zip_path, exdir = out.dir2) #unzip
            X = read.csv(csv_path, header = F)
            save(X, file = rdata_path)
            file.remove(zip_path); file.remove(csv_path)
            rm(X); gc()
          } else if (url.exists(url2)) {
            download.file(url = url2, destfile = zip_path) 
            unzip(zip_path, exdir = out.dir2) #unzip
            X = read.csv(csv_path, header = F)
            save(X, file = rdata_path)
            file.remove(zip_path); file.remove(csv_path)
            rm(X); gc()
          } else {
            stop (paste0("The file ", datname,
                         ".zip wasnt found to be downloaded"))
          }
          cat(datname, "took", 
              ((proc.time()-ptm)["elapsed"])/60, "mins\n")
        }, error = function(e) {
          print(paste0("Something went wrong downloading/writing the data for ", paste0(pair, "-", year, "-", month)))
        })
      }
    }
  }
  warning("**** IMPORTANT *****\n\nTHERE ARE OFTEN ERRORS DUE TO (I ASSUME) INTERNET DISCONNECTION WHICH MEAN YOU MAY HAVE TO RUN THE ABOVE MANY TIMES TO SUCCESFFULY DOWNLOAD ALL THE FILES\n\n")
}

#####################################################################
#             CODE TO TEST FUNCTION
#####################################################################

#### *** WARNING TAKES ~5MINS FOR EVERY COMBO OF YEAR/PAIR/MONTH**
pairs = "AUDNZD"
years = "2017"
months = c("01", "02", "03")
out.dir = "C:/Users/Strategy/Desktop/Jonathan/Personal/Trading/Outputs/DownloadTFXData"
skip_if_exists = T

#Run function
DownloadTFXData(pairs, months, years, out.dir, skip_if_exists)
  
