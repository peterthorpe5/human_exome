library(tidyverse)

# INPUT #
path = '~/Documents/PhD_data/'

setwd(path)

filename <- list.files(pattern = '*.txt')
message('Reading files')
for (i in filename) {
  message(paste(i))
  assign(i, fread(i, header = T, stringsAsFactors = F, logical01 = F, keepLeadingZeros = T, select = c('Chr','Start','Otherinfo11','Gene.refGene'), colClasses = 'character'))
}

all_families <- bind_rows(
  fam300_output.myanno.hg19_multianno.txt %>% mutate(fam = 'fam300', ID =paste(Chr,Start, sep = ':')),
  fam315_output.myanno.hg19_multianno.txt %>% mutate(fam = 'fam315', ID =paste(Chr,Start, sep = ':')),
  fam323_output.myanno.hg19_multianno.txt %>% mutate(fam = 'fam323', ID =paste(Chr,Start, sep = ':')),
  fam387_output.myanno.hg19_multianno.txt %>% mutate(fam = 'fam387', ID =paste(Chr,Start, sep = ':')),
  fam430_output.myanno.hg19_multianno.txt %>% mutate(fam = 'fam430', ID =paste(Chr,Start, sep = ':')),
  fam489_output.myanno.hg19_multianno.txt %>% mutate(fam = 'fam489', ID =paste(Chr,Start, sep = ':')),
  )

summary <- all_families %>% group_by(ID) %>% summarise(
  Tot = n(),
  Gene = Gene.refGene[1],
  fam = paste0(fam, collapse = ';')
) %>% filter(Tot >= 2)
