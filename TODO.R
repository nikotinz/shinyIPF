# Tab 1
# Sidebar: add a drop down options for year_class_selector exclude Sub-Junior and Junior and vice versa (maybe three-way switch)
# Sidebar: add references for the data
# Sidebar: check that options "All" in dropdown selector are in capital
# Sidebar: add filter by year of the comps
# Plots: x-lim for lift plots so they fit  min and max lifts
# Plots: change colours of the plots for S, B, D
# Plots: fix annotation overlapping with axis
# Plots: add options for plotly to zoom fullscreen
# Plots: remove control panel and zoom options
# Plots: fix hover text
# Bottom text area: Add count(n) of both 3 lifts
# Bottom text area: Add brief description of the tab
# Bottom text area: Add explanation of Quantile

# Tab 2
# Lifts selector - when user select lift what is the most popular choice is for the next lift etc
# Bottom text area: Add brief description of the tab

shiny::runApp("C:/GIT/shinyIPF/")

rsconnect::setAccountInfo(
  name = 'nikotinz',
  token = 'EF56D61AD571EC61D59DB6C74D67378C',
  secret = 'Ec2cCC5NBqauj/m+/cV3kgwH6yd6drnlBMYXAr9A'
)

rsconnect::deployApp('C:/GIT/shinyIPF/')
