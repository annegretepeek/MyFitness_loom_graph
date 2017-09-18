#Andmed loom graphi jaoks
library(dplyr)
load("C:/MyFit/kesklinn.RData")
kesk <- trennid
load("C:/MyFit/lõunakas.RData")
trennid <- rbind(trennid, kesk)
trennid <- trennid[trennid$kohti != 0,] #Eemaldan jõusaali valvetreenerid
sort(table(trennid$treener), decreasing = TRUE)
treenerid <- c("Lene Vardja", "Merike Sula", "Inga Neissaar", "Maigi Varusk", "Kristi MÃ¶ldri", "Kirsti Kuhi",  "Egle Villik")
trennid2 <- trennid[trennid$treener %in% treenerid,]
sort(table(trennid2$nimi), decreasing = TRUE)
trennid2$nimi[trennid2$nimi %in% c("BodyPump+MyFit abs", "BodyPump Maraton 1,5 h", "BodyPump+Stretching", "BodyPump100", "BodyPump45", " BodyPump")] <- "BodyPump"
trennid2$nimi[trennid2$nimi %in% c("Nike Training Club45", "Nike Training Club Challenge Endurance", "Nike Training Club Challenge Mobility", 
                                   "Nike Training Club Challenge Strength", "Nike Training club", "NTC Strength", "Nike Training Club välitreening Maraton 1,5 h",
                                   "Nike Training Club vÃ¤litreening", "Nike Training Club vÃ¤litreening Maraton 1,5 h")] <- "Nike Training Club"
trennid2$nimi[trennid2$nimi %in% c("BodyAttack45", "BodyAttack+MyFit abs", "BodyAttack+MyFit abs Maraton 1,5 h")] <- "BodyAttack"
trennid2$nimi[trennid2$nimi %in% c("MyFit Abs", "MyFit abs+Stretching")] <- "MyFit abs"
trennid2$nimi[trennid2$nimi %in% c("BodyCombat45")] <- "BodyCombat"
trennid2$nimi[trennid2$nimi %in% c("KÃµht selg tuhar45", "Kõht selg tuhar", "KÃµht selg tuhar")] <- "Kõht selg tuhar"
trennid2$nimi[trennid2$nimi %in% c("Ã\u0095nnevalem BodyBalance")] <- "BodyBalance"
trennid2$nimi[trennid2$nimi %in% c("BodyJam Maraton 2,0 h", "BodyJam45")] <- "BodyJam"
trennid2$nimi[trennid2$nimi %in% c("Bosu45")] <- "Bosu"
trennid2$nimi[trennid2$nimi %in% c("Interval30 + Fit", "Interval+ Fit", "Interval+Fit")] <- "Interval + Fit"
trennid2$nimi[trennid2$nimi %in% c("BodyVive45")] <- "BodyVive"
trennid2$nimi[trennid2$nimi %in% c("Step Maraton 1,5 h")] <- "Step"
sort(table(trennid2$nimi), decreasing = TRUE)

#Võtame veel kokku
trennid2$nimi[trennid2$nimi %in% c("BodyJam", "Zumba", "StripDance", "DanceFusion", "Zumba45", "Dance")] <- "Tants"
trennid2$nimi[trennid2$nimi %in% c("Uphill45", "Interval + Fit", "Maraton", "Interval")] <- "Ratas"
trennid2$nimi[trennid2$nimi %in% c("YOGAFUNC", "bodyART", "Stretching")] <- "Body & Mind"
trennid2$nimi[trennid2$nimi %in% c("BodyCombat", "Step", "Nike Training Club", "BodyVive", "Bosu", "deepWORK", "GRIT Strength", "Total Body HIIT", 
                                   "Fitball Toning45", "Fit")] <- "Muu"

trennid2$treener[trennid2$treener == "Kristi MÃ¶ldri"] <- "Kristi Möldri"

trennid2 <- trennid2 %>% group_by(nimi, treener) %>% summarise(arv = n())

library(jsonlite)
out <- toJSON(trennid2, auto_unbox = TRUE, pretty = TRUE)
prettify(out) 

write(out, "data_loom.json")
