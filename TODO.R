# Tab 1
# Sidebar: add a drop down options for year_class_selector exclude Sub-Junior and Junior and vice versa (maybe three-way switch)
# Sidebar: add references for the data
# Sidebar add a selector for federation
# Plots: x-lim for lift plots so they fit  min and max lifts
# Plots: Add input value to the user lifts
# Plots: Add line to show a user lifts on the density curve
# Plots: Add quantile text on the plot
# Plots: change colours of the plots for S, B, D
# Plots: Add Total lifts plot
# Bottom text area: add count(n) of both 3 lifts
# Bottom text area: Add brief description of the tab

# Tab 2: Lifts selector - when user select lift what is the most popular choice is for the next lift etc
# Bottom text area: Add brief description of the tab

shiny::runApp("C:/GIT/shinyIPF/")

rsconnect::setAccountInfo(
  name = 'nikotinz',
  token = 'EF56D61AD571EC61D59DB6C74D67378C',
  secret = 'Ec2cCC5NBqauj/m+/cV3kgwH6yd6drnlBMYXAr9A'
)

rsconnect::deployApp('C:/GIT/shinyIPF/')

fed_choices <- as.character(unique(ipf_df$federation))
shiny::selectizeInput(
  inputId = "federation_selector",
  label = "Federation",
  choices = c("All", fed_choices),
  options = list(placeholder = 'Type to search...')
)
