## =============================== License ========================================
## ================================================================================
## This work is distributed under the MIT license, included in the parent directory
## Copyright Owner: University of Oxford
## Date of Authorship: 2016
## Author: Martin John Hadley (orcid.org/0000-0002-3039-6849)
## Academic Contact: Claire Bloomfield orcid.org/0000-0002-3122-3069 and Kevin McGlynn orcid.org/0000-0002-0257-7749
## Data Source: NA
## ================================================================================

appCSS <- "
#loading-content {
position: absolute;
background: #000000;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #FFFFFF;
}
"

library(shiny)
library(igraph)
library(visNetwork)
library(highcharter)
library(shinyBS)
library(shinyjs)

shinyUI(navbarPage(
  tags$head(tags$script(src="iframeResizer.js")),
  "",
  tabPanel(
    "Welcome",
    fluidPage("Welcome to the CRUK Collaboration Network explorer")
  ),
  tabPanel(
    "Centre",
    fluidPage(useShinyjs(),
              inlineCSS(appCSS),
      tags$head(
        tags$script(
          '
          Shiny.addCustomMessageHandler("scrollDown",
          function(color) {
          var y = $(window).scrollTop();  //your current y position on the page
          $(window).scrollTop(y+200);
          }
          );'
    )
        ),
    wellPanel(
      "Collaboration overview for the entire institution, see elsewhere (LINKS) for department/person overview"
    ),
    bsCollapse(
      id = "collapseExample",
      open = NULL,
      bsCollapsePanel(HTML(
        paste0(
          '<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>',
          "Institution Overview (click to expand)"
        )
      ),
      fluidPage(
        uiOutput("institution_app_collapsile_info")
      ), style = "primary")
    ),
    fluidRow(
      column(
        wellPanel(
          selectInput(
            "institution_people_or_departments",
            label = "Display:",
            choices = c("individuals", "departments")
          )
        ),
        uiOutput("insitution_displayed_network_properties"),
        uiOutput("institution_selected_node_sidePanel"),
        width = 4
      ),
      column(
        div(
          id = "loading-content",
          h2("Computing fancy forceatlas2 layout")
        ),
        visNetworkOutput("institution_displayed_network", width = "100%"),
        actionButton("institution_refocus_network", "Refocus Network", width = "100%"),
        width = 8
      )
    ),
    highchartOutput("institution_highchart_node_legened", height = "150px"),
    uiOutput("institution_selected_node_table_UI")
    # wellPanel(
    #   DT::dataTableOutput("selected_node_table")
    # )
    
      )
  ),
  tabPanel(
    "Department",
    fluidPage(
      tags$head(
        tags$script(
          '
          Shiny.addCustomMessageHandler("scrollDown",
          function(color) {
          var y = $(window).scrollTop();  //your current y position on the page
          $(window).scrollTop(y+200);
          }
          );'
    )
        ),
    uiOutput("select_department_UI"),
    uiOutput("department_app_title"),
    uiOutput("department_app_description"),
    bsCollapse(
      id = "collapseExample",
      open = NULL,
      bsCollapsePanel(HTML(
        paste0(
          '<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>',
          " Deparment Overview (click to expand)"
        )
      ),
      fluidPage(
        uiOutput("department_app_collapsile_info")
      ), style = "primary")
    ),
    tabsetPanel(
      tabPanel(
        "People Directory",
        uiOutput("department_people_directory_UI")
      ),
      tabPanel(
        "Department Collaboration Network",
        fluidPage(
          fluidRow(
            column(
              selectInput(
                "people_or_departments",
                "Show?",
                choices = c("within department", "within whole network")
              ),
              uiOutput("department_network_edge_degree_UI"),
              uiOutput("department_selected_node_sidePanel"),
              width = 4
            ),
            column(visNetworkOutput("department_displayed_network"),
                   actionButton("department_refocus_network", "Refocus Network", width = "100%"),
                   width = 8)
          ),
          highchartOutput("department_highchart_node_legened", height = "150px"),
          uiOutput("department_selected_node_table_UI")
        )
      )
    )
      )
    ),
  tabPanel(
    "Principal Investigators",
    fluidPage(
      wellPanel(
        "This page provides a directory of all PIs in the institution, note that at present the data is quite minimal as we are awaiting in change in the structure of data to make it easier for all of an individual's interactions to be seen at once. For demonstrative purposes, a computation of the number of interactions in database has been made and is displayed below."
      ),
      DT::dataTableOutput("PI_people_directory")
    )
  )
  
  
  ,
  collapsible = TRUE
  ))