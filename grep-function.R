##-------------------------------------------------------------------
# create a function to grep column y for a vector of search terms, x

grep_for_x_in_y <- function(x, y)
        # grep for each element in x within y, then format results
        # Arguments:
        #   x: vector of character strings to search for
        #   y: vector of character strings in which to search
        # Returns:
        #   integer vector of positions in y with something in x
{
        position_list <- lapply(x, function(x_element)
                grep(x_element, y, ignore.case = TRUE))
        position_vector <- do.call(c, position_list)
        sort(unique(position_vector))
}

## create a vector of searchable terms across five covariates
x <- c("William", 
       "Drew",  
       "Adam", 
       "Austin")
       
## specify a column of the data to search through
y <- dat$team_members

## apply the function and save the results as a data frame of row numbers
new_dat <- as.data.frame(grep_for_x_in_y(x, y)) 
