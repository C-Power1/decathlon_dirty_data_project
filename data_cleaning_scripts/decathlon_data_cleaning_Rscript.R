
#Loading in libraries 

library(tidyverse) 
library(here)

here::here() #checking directory path

decathlon <- read_rds(here("raw_data/decathlon.rds"))

view(decathlon)

dim(decathlon) #Returns number of rows and columns

names(decathlon) #returns variable names

row.names(decathlon) # returns row names

# Changing row names to column 1

row_names_to_column_1 <- rownames_to_column(decathlon, var = "athlete") 
#taking the row names and putting them into a new column called athlete

view(row_names_to_column_1)


# Moving data from wide format to long


longer_decathlon <- row_names_to_column_1 %>% 
  pivot_longer(cols = 2:11,
               # taking columns 2 to 11
               names_to = "event",
               # and putting their names into one column called "event"
               values_to = "distance_or_time") # putting the values from columns 2 to 11 into a column called "distance_or_time"

view(longer_decathlon)



# Changing all column titles to tidy 


tidy_col_names <- longer_decathlon %>%
  rename("rank" = `Rank`,
         "points" = `Points`,
         "competition" = `Competition`)
#rename() allows columns to be changed to lower case
tidy_col_names

#changing columns so that all columns names are in lower case

cols_to_lower <- tidy_col_names %>% 
  mutate(athlete = tolower(athlete)) %>% #changing all obvs to lower case in athlete column
  mutate(event = tolower(event)) %>% #changing all obvs to lower case in event column
  mutate(competition = tolower(competition)) #changing all obvs to lower case in competition column

view(cols_to_lower)


# Finally, replacing the full stops in the events column to underscores and tidying up the competition column


clean_decathlon <- athlete_to_title %>%
  mutate(event = str_replace_all(event,
                                 "\\.",
                                 "_")) %>% 
  mutate(competition = str_replace_all(competition,
                                       "\\g",
                                       "s"))

view(clean_decathlon)


# Writing clean data to csv file

write_csv(clean_decathlon, "clean_data/cleaned_decathlon_data.csv")
