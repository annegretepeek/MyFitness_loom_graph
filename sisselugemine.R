##Scraping
library(dplyr)
library(tidyr)
library(rvest)

#setwd("../MyFit")

# 4 lõunakas, 8 kesklinn
#listcsv <- dir(pattern = "*_4.html")
listcsv <- dir(pattern = "*_8.html")
trennid <- data.frame(p2ev = character(), kuup2ev = character(), n2dal = numeric(), nimi = character(), treener = character(), ruum = character(), kohti = character(), reganud = character())
for (k in 1:length(listcsv)) {
  print(listcsv[k])
  week <- read_html(listcsv[k])
  andmed <- week %>% html_nodes(".day")
  for (i in 8:length(andmed)) {
    if (!identical(andmed[i] %>% html_nodes(".bron-tooltip .title") %>% html_text(), character(0))){
      if (i %% 7 != 0) {
        p2ev <- andmed[i %% 7] %>% html_text()
        kuup2ev <- (week %>% html_nodes(".date") %>% html_text())[i %% 7]
      } else {
        p2ev <- andmed[7] %>% html_text()
        kuup2ev <- (week %>% html_nodes(".date") %>% html_text())[7]
      }
      n2dal <- as.numeric(gsub("_.*$", "", listcsv[k]))
      nimi <- andmed[i] %>% html_nodes(".bron-tooltip .title") %>% html_text()
      treener <- andmed[i] %>% html_nodes(".bron-tooltip .name") %>% html_text()
      ruum <- andmed[i] %>% html_nodes(".bron-tooltip .room") %>% html_text()
      kohti <-  andmed[i] %>% html_nodes(".bron-tooltip .places") %>% html_text()
      reganud <- andmed[i] %>% html_nodes(".bron-tooltip .registered") %>% html_text()
      trennid <- rbind(trennid, data.frame(p2ev, kuup2ev, n2dal, nimi, treener, ruum, kohti, reganud))
    }
  }
}
trennid <- data.frame(lapply(trennid, as.character), stringsAsFactors = FALSE)
trennid <- trennid %>% separate(nimi, c("nimi", "aeg"), "\\(")
trennid$aeg <- gsub( "\\).*$", "", trennid$aeg)
trennid$nimi <- gsub("^\\s+|\\s+$", "", trennid$nimi)
trennid$nimi <- gsub("/.*$", "", trennid$nimi)
trennid$treener <- gsub("^\\s+|\\s+$", "", trennid$treener)
trennid$ruum <- gsub("^\\s+|\\s+$", "", trennid$ruum)
trennid$kohti <- gsub("^\\s+|\\s+$", "", trennid$kohti)
trennid$reganud <- gsub("^\\s+|\\s+$", "", trennid$reganud)
trennid$kohti <- as.numeric(gsub( "^.*\\s+", "", trennid$kohti))
trennid$reganud <- as.numeric(gsub( "^.*\\s+", "", trennid$reganud))
trennid <- trennid %>% separate(aeg, c("algus", "l6pp"), " - ")
trennid$nimi <- gsub("^.*?! ","",trennid$nimi)
trennid$nimi <- gsub("^.*?!","",trennid$nimi)
trennid <- trennid[trennid$treener != "",]

save(trennid, file = "C:/Users/annegrete.peek/Documents/D3/MyFitness/kesklinn.RData")
#save(trennid, file = "C:/Users/annegrete.peek/Documents/D3/MyFitness/lõunakas.RData")
