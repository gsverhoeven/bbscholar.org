# NAF dataprep script: from dump tot analysis file

refresh_source <- 0

if (refresh_source){
  library(fs)
  zip_url  <- "https://member.thenaf.net/glicko/nafstat-tmp-name.zip"  
  zip_file <- "data/nafstat-tmp-name.zip"
  ex_dir   <- "data"
  
  # 1. start with clean slate
  csv_files <- dir_ls(ex_dir, glob = "*.csv", type = "file")
  file_delete(csv_files)
  
  # 2. Download the zip file
  # Crucial: Use mode = "wb" for binary files like zip files to prevent corruption
  download.file(
    url = zip_url, 
    destfile = zip_file, 
    mode = "wb"
  )
  
  # 3. Unzip the file locally
  unzip(
    zipfile = zip_file, 
    exdir = ex_dir,
  )
  
  # 4. Move the CSV files one folder up, remove empty folder
  sub_dirs <- dir_ls(ex_dir, type = "directory")
  files_to_move <- dir_ls(sub_dirs, type = "file")  
  file_move(path = files_to_move, new_path = "data")
  dir_delete(sub_dirs)

}

library(tidyverse)

naf_ranking <- read_csv2("data/naf_coachranking_variant.csv")
naf_coaches <- read_csv2("data/CoachExport.csv")
colnames(naf_coaches) <- c("coach_id", "coach_name", "country", "regdate", "exp_date")
naf_games <- read_csv2("data/naf_game.csv")
naf_race <- read_csv2("data/naf_race.csv")
naf_variants <- read_csv2("data/naf_variants.csv")
naf_tournament <- read_csv2("data/naf_tournament.csv") %>% select(tournamentid, tournamentname, tournamentstartdate, tournamentenddate)


df1 <- naf_games %>%
  select(gameid, date, tournamentid, naf_variantsid, homecoachid, racehome, goalshome, goalsaway) # newdate is date time in character format

colnames(df1) <- c("gameid" , "date", "tournamentid", "variantid", "coach_id", "raceid", "td_for", "td_against")
df2 <- naf_games %>%
  select(gameid, date, tournamentid, naf_variantsid, awaycoachid, raceaway, goalsaway, goalshome)
colnames(df2) <- c("gameid" , "date", "tournamentid", "variantid", "coach_id", "raceid", "td_for", "td_against")

df <- rbind(df1, df2)

df <- df %>%
  left_join(naf_race %>% select(raceid, name), by = join_by(raceid)) %>%
  filter(!(raceid %in% c(99, 32, 27)))

df <- df %>%
  left_join(naf_variants %>% select(variantid, variantname), by = join_by(variantid)) %>%
  filter((variantid %in% c(1, 13, 15))) # classic,online, bb2020, bb2025, 16 regular is Regular (Classic, BB2020, BB2025). 
# 4 and 8 are removed (sevens and online)

df <- df %>%
  left_join(naf_tournament, by = join_by(tournamentid))

df$year <- year(df$date)
df$month <- month(df$date)
df$week <- week(df$date)

df <- df %>% mutate(month_date = make_date(year, month, 1))

df <- df %>%
  mutate(win = if_else((td_for - td_against) > 0, 1, 0)) %>%
  mutate(win = if_else(td_for == td_against, 0.5, win))

df <- df %>%
  left_join(naf_coaches %>% select(coach_id, coach_name, country), by = join_by(coach_id))


# flag data errors
df <- df %>%
  mutate(gamedate_ok = date %within% interval(tournamentstartdate - 7, tournamentenddate  + 7),
         gamedate_ok_strict = date %within% interval(tournamentstartdate, tournamentenddate))

#table(df$gamedate_ok)

res <- df %>% 
 group_by(year) %>%
 summarise(mean(gamedate_ok), mean(gamedate_ok_strict))

# It would have probably gone unnoticed for a a while, if it wasn’t due to our diligent data cruncher Sann0638 – but in February 2023 we are celebrating the 20th birthday of the first ever recorded NAF match! Or I should better say, the 20th birthday of the first ever NAF recording. The (I must assume) glorious match between Rekrap’s Norse and Lutha_Harex’ High Elves ended with a 3-2 for the Norse.
# 
# The match was already played in October at the Spiky Open Cup 2002 in Reading (UK), which was eventually won by Sputnik’s Lizardmen, but didn’t make it into the database until February 2003. However, the older ones among you will remember how it was back then in 2002, when everybody was still connecting through 28.8kbps modems. It was completely normal for an upload to take four months.
# 
# Who would have thought back then how many more recorded matches would follow. Since February 2003, more than 336’000 additional matches have found their way into the NAF database!
# 



