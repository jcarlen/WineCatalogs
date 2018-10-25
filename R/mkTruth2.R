# Jane Carlen
#
# GOAL: Polish the truth in "Truth1" which was created with mkTruth.R
# Truth1 is available in the DSL drive and here: http://dsi.ucdavis.edu/WineCatalogs/
# You must set your "pathtotruth" directory below accordingly
# 
# Output: 
# Files will output to a "Truth2" folder at the same level as Truth 1
# Standardize column names
# 1, 2, ... left to right
# Possible names: No, Case, Bottle, 
# Skipping description for now, can circle back
######################################################################################

# 0. Setup ####

pathtorepo = "~/Desktop/readingforward/wine_catalogue/WineCatalogs/"
pathtotruth = "~/Desktop/readingforward/Truth1/"
  
setwd(pathtorepo)
cat_files = readRDS("Data/cat_files.RDS")

# 1. Pick an image ####

#filenum = sample(str_extract(list.files(pathtotruth), "[0-9]{4}"), 1) #picks randomly
filenum = "1994"
filename = paste0(pathtotruth, filenum, ".csv", sep="")

# which catalog is it in
which_cat = which(unlist(lapply(cat_files, function(x) {
  sum(grepl(paste(".*", filenum, sep=""), x$file.jpg))
}))>0)

# any other truth files in that catalog ?
# str_extract(as.character(cat_files[[which_cat]]$file.jpg), "[0-9]{4}") %in% str_extract(list.files(path = "Truth1"), "[0-9]{4}")

# 2. Look at the image
pageID = cat_files[[which_cat]][which(grepl(filenum, cat_files[[which_cat]]$file)), "page_id"]
catID = cat_files[[which_cat]][which(grepl(filenum, cat_files[[which_cat]]$file)), "catalog_id"]
browseURL(paste0("https://ptv.library.ucdavis.edu/#", catID, "/", pageID, sep=""))

# 3. fix the image & save -- ADD MORE CODE HERE FOR ALL IMAGES

###### 0008
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$No. = c(truth1$No.[1:8], "A41", "A43", "A45", truth1$No.[11:14], "A61", truth1$No.[16:18])
truth1$Case = as.character(sort(c(truth1$Case, 55.75)))
truth1$No..1 = c(truth1$No..1[1:8], "B41", "B43", truth1$No..1[10:18])
truth1$Case.1[c(2,7,9)] = c("35.75", "--", "41.75")
truth1$Case.1 = c(truth1$Case.1[1:9], "49.75", truth1$Case.1[10:18])
truth1 = data.frame(No1 = as.character(truth1$No.), Case1 = as.character(truth1$Case), 
                    No2 = as.character(truth1$No..1), Case2 = as.character(truth1$Case.1))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

###### You can keep adding labels for fixed files...

###### 0267_p1
# Row 15 column 3 had a comma issue that had to be fixed before running the rest of this cleaning
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Bin = c(truth1$Bin[1:47])
truth1$Description = c(truth1$Description[1:47])
truth1$Bottle = c(truth1$Bottle[1], "0.69", truth1$Bottle[3:13], "1.19", truth1$Bottle[15:47])
truth1$Case = c(truth1$Case[1:14], "26.75", truth1$Case[16:28], "27.95", truth1$Case[30:35], "54.00", truth1$Case[37:47])
truth1 = list(data.frame(Bin = as.character(truth1$Bin), Description = as.character(truth1$Description), 
                         Bottle = as.character(truth1$Bottle), Case = as.character(truth1$Case)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

###### 0267_p2
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Bin = c(truth1$Bin[1:42], "151", truth1$Bin[44:52])
truth1$Description = c(truth1$Description[1:13], "CHATEAU LAFON ROCHET (St. Estephe) 1/2 - Bottles", 
                       truth1$Description[15:44], "CHATEAU LATOUR (Pauillac)", truth1$Description[46:52])
truth1$Bottle = c("6.49", truth1$Bottle[2:10], "12.89", truth1$Bottle[12:24], "6.49", truth1$Bottle[26], 
                  "2.99",truth1$Bottle[28:36], "1.35", truth1$Bottle[38:52])
truth1$Case = c("75.00", truth1$Case[2:3], "24.65", truth1$Case[5:11], "85.00", truth1$Case[13:17], "62.50",
                truth1$Case[19:22], "69.00", truth1$Case[24:29], "26.50", truth1$Case[31:37], "85.00",
                truth1$Case[39:42], "85.00", truth1$Case[44:52])
truth1 = list(data.frame(Bin = as.character(truth1$Bin), Description = as.character(truth1$Description), 
                         Bottle = as.character(truth1$Bottle), Case = as.character(truth1$Case)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

###### 0321
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$NumBottles = c(truth1$NumBottles[1:23])
truth1$BinNum = c(truth1$BinNum[1:23])
truth1$Description = c(truth1$Description[1:11], "POUILLY BLANC FUME 1969, La Doucette (A classic dry white wine)", 
                       "CHATEAUNEUF DU PAPE 1967, Beaucastel (A full, vigorous red)", truth1$Description[14:17], 
                       "SOAVE 1967, Cantina Sociale (Italy's best dry white wine)", truth1$Description[19:20],
                       "SCHLOSS VOLLRADS “RED SEAL” 1969, Graf Matuschka-Greiffenclou (A classic example of the finesse that can be achieved along the Rhine River)",
                       truth1$Description[22:23])
truth1$PriceBottle = c(truth1$PriceBottle[1:20], "3.29", truth1$PriceBottle[22:23])
truth1$Price2Bottles = c(truth1$Price2Bottles[1:20], "6.58", truth1$Price2Bottles[22:23])
truth1 = list(data.frame(NumBottles = as.character(truth1$NumBottles), BinNum = as.character(truth1$BinNum), 
                         Description = as.character(truth1$Description), 
                         PriceBottle = as.character(truth1$PriceBottle), Price2Bottles = as.character(truth1$Price2Bottles)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

####### 1544_coulmn1.csv
setwd(pathtotruth)
file.rename("1544_coulmn1.csv", "1544_column1.csv")
filenum = "1544_column1"
filename = paste0(pathtotruth, filenum, ".csv", sep="")
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Bin = c(truth1$Bin[1:6])
truth1$Description = c(truth1$Description[1:6])
truth1$Case = c(truth1$Case[1:6])
truth1$CaseArrival = c(truth1$CaseArrival[1:6])
truth1 = list(data.frame(Bin = as.character(truth1$Bin), Description = as.character(truth1$Description), 
                         Case = as.character(truth1$Case), CaseArrival = as.character(truth1$CaseArrival)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

####### 1544_coulmn2.csv
#manually added a comma after 99.00 of line 9
setwd(pathtotruth)
file.rename("1544_coulmn2.csv", "1544_column2.csv")
filenum = "1544_column2"
filename = paste0(pathtotruth, filenum, ".csv", sep="")
truth1 = as.list(read.csv(filename, stringsAsFactors = F, sep=","))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = ""))

###### 1835_column1_bottom
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Description = c(truth1$Description[1], "S. S. PIERCE GOLD COAST (American)", truth1$Description[3:6],
                       "S. S. PIERCE GOLD COAST (American)", truth1$Description[8:12], "CINZANO BIANCO", 
                       truth1$Description[14], truth1$Description[16:24], "ST. RAPHAEL (France)", truth1$Description[26:27]
                       )
truth1$Bottle = c(truth1$Bottle[1:14], truth1$Bottle[16:27])
truth1 = list(data.frame(Description = as.character(truth1$Description), Bottle = as.character(truth1$Bottle)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

###### 1835_column1_top
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Description = c(truth1$Description[1], "ENCANTO AMONTILLADO (Dry)", truth1$Description[3:15],
                       "HARVEY'S AMONTILLADO (Dry)", truth1$Description[17:34]
)
truth1$Bottle = c(truth1$Bottle[1:34])
truth1$Case = c(truth1$Case[1:5], "24.00", truth1$Case[7:18], "43.00", truth1$Case[20:24], "64.15", truth1$Case[26:34])
truth1 = list(data.frame(Description = as.character(truth1$Description), Bottle = as.character(truth1$Bottle), 
                         Case = as.character(truth1$Case)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = ""))

###### 1835_column2
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Description = c(truth1$Description[1:6], "*HINE FIVE STAR", truth1$Description[8:20], "*MARTEL EXTRA",
                       truth1$Description[22:33]
                      )
truth1 = list(data.frame(Description = as.character(truth1$Description), Bottle = as.character(truth1$Bottle), 
                         Case = as.character(truth1$Case)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = ""))

###### 1994
truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$Case = c("18.95", truth1$Case[2:28])
truth1 = list(data.frame(Description = as.character(truth1$Description), Bottle = as.character(truth1$Bottle), 
                         Case = as.character(truth1$Case)))
# Save output to Truth2
saveRDS(truth1, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = ""))

#truth2 = readRDS("~/Desktop/readingforward/Truth2/1994.RDS")
#truth1 = read.csv("~/Desktop/readingforward/Truth1/1835_column1_bottom.csv", sep=",")
######################################################################################
# IGNORE
##### fixed one more from the same catalog as 0008 (from scratch)
# filenum = "0027"
# truth2 = list()
# truth2$No1 = c("329", "668", "571", "250", "244", "338", "509", "224", "308", "315", "285", "259")
# truth2$Bottle1 = c("1.99", "2.49", "2.49", "3.49", "3.49", "3.69", "3.79", "3.79", "3.99", "3.99", "3.99", "3.99")
# truth2$Case1 = c("21.50", "26.90", "26.90", "37.70", "37.70", "39.85", "40.95", "40.95", "43.10", "43.10", "43.10", "43.10")
# truth2$No2 =  c("276", "440", "759", "5010", "403", "5033", "394", "372", "798", "1079")
# truth2$Bottle2 = c("4.49", "4.49", "4.79", "4.79", "5.79", "5.89", "5.99", "6.79", "12.50", "16.50")
# truth2$Case2 = c("48.50","48.50", "51.75", "51.75", "62.55", "63.60", "64.70", "74.75", "135.00", "178.00")
# saveRDS(truth2, paste0(pathtotruth,"..","/Truth2/",filenum,".RDS", sep = "")) #save as RDS in case of uneven row numbers for diff columns (csv won't work)

