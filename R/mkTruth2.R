# Polish the truth in "Truth1" which was created with mkTruth.R
# 10-4-18
# Truth1 folder at http://dsi.ucdavis.edu/WineCatalogs/Truth1.tar.gz, more backround at http://dsi.ucdavis.edu/WineCatalogs

# Standardize column names
# 1, 2, ... left to right
# Possible names: No, Case, Bottle, 
# Skipping description for now, can circle back

# 0. Setup ####

setwd("~/Documents/DSI/OCR_SherryLehmann")

cat_files = readRDS("../cat_files.RDS")

# 1. Pick an image ####

#nums in Truth
str_extract(list.files(), "[0-9]{4}")

#pick one
filename = "Truth1/0008.csv"

#which catalog is it in
filenum = strsplit(filename, "\\.|/")[[1]][2]c
#load("Sample/.RData") #containts cat_files
readRDS("~/Documents/DSI/WineCatalogs_forked_repo/FineTuneTraining/")
which_cat = which(unlist(lapply(cat_files, function(x) {
  sum(grepl(paste(".*", filenum, sep=""), x$file.jpg))
}))>0)

#any other truth files in that catalog ?
str_extract(as.character(cat_files[[which_cat]]$file.jpg), "[0-9]{4}") %in% #nums in Truth
       str_extract(list.files(path = "Truth1"), "[0-9]{4}")

# 2. fix the image

truth1 = as.list(read.csv(filename, stringsAsFactors = F))
truth1$No. = c(truth1$No.[1:8], "A41", "A43", "A45", truth1$No.[11:14], "A61", truth1$No.[16:18])
truth1$Case = sort(c(truth1$Case, 55.75))
truth1$No..1 = c(truth1$No..1[1:8], "B41", "B43", truth1$No..1[10:18])
truth1$Case.1[c(2,7,9)] = c("35.75", "--", "41.75")
truth1$Case.1 = c(truth1$Case.1[1:9], "49.75", truth1$Case.1[10:18])
truth1 = as.list(data.frame(No1 = truth1$No., Case1 = truth1$Case, No2 = truth1$No..1, Case2 = truth1$Case.1))

# 2b. fix one more from the same catalog (from scratch)

filenum = "0027"
truth2 = list()
truth2$No1 = c("329", "668", "571", "250", "244", "338", "509", "224", "308", "315", "285", "259")
truth2$Bottle1 = c("1.99", "2.49", "2.49", "3.49", "3.49", "3.69", "3.79", "3.79", "3.99", "3.99", "3.99", "3.99")
truth2$Case1 = c("21.50", "26.90", "26.90", "37.70", "37.70", "39.85", "40.95", "40.95", "43.10", "43.10", "43.10", "43.10")
truth2$No2 =  c("276", "440", "759", "5010", "403", "5033", "394", "372", "798", "1079")
truth2$Bottle2 = c("4.49", "4.49", "4.79", "4.79", "5.79", "5.89", "5.99", "6.79", "12.50", "16.50")
truth2$Case2 = c("48.50","48.50", "51.75", "51.75", "62.55", "63.60", "64.70", "74.75", "135.00", "178.00")

# 3. Save in Truth2
write.csv(truth1, file = "Truth2/0008.RDS", row.names = F)
saveRDS(truth1, file = "Truth2/0008.RDS")
#  unequal row names -> now csv
saveRDS(truth2, file = paste("Truth2/", filenum,".RDS", sep=""))


