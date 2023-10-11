library(shiny)
library(yaml)
library(shinyjs) # Import shinyjs

# Define the YAML file path

config_dir <- file.path(Sys.getenv("USERPROFILE"), ".config")

yaml_file <- file.path(Sys.getenv("USERPROFILE"), ".config", ".shrtcts.yaml")

ui <- fluidPage(
  
  useShinyjs(), # Initialize shinyjs
  
  tags$head(tags$style(HTML("
    #leftCol {
      position: fixed;
      top: 50px;
      left: 15px;
      bottom: 10px;
      overflow: hidden;
      padding-right: 20px;
    }
    #rightCol {
      margin-left: 25%;
      overflow-y: scroll;
      height: calc(100vh - 100px);
      padding-left: 20px;
    }

    /* Responsive behavior for screens with a max-width of 800px */
    @media (max-width: 800px) {
      #leftCol {
        position: relative;
        top: auto;
        left: auto;
        bottom: auto;
        width: 100%;
        padding-right: 0px;
      }
      #rightCol {
        margin-left: 0;
        padding-left: 0;
        height: auto;
      }
    }
  "))),
  
  titlePanel("ShinyWrappR"),
  fluidRow(
    column(3,
           id = "leftCol",
           textAreaInput("readme", "", "", rows = 10 ),
           textInput("searchInput", "Search"), # Add search input
           actionButton("addEntry", "Add Entry"),
           br(),
           actionButton("saveYaml", "Save YAML")

    ),
    column(8,
           id = "rightCol",
           uiOutput("entries")
    )
  ),
  br(),
  tags$script(HTML("
    $(document).on('keyup', '#searchInput', function() {
      var searchVal = $(this).val().toLowerCase();
      if(searchVal) {
        $('#addEntry, #saveYaml').prop('disabled', true);
        $('.entry-div').hide().filter(function() {
          var divInputs = $(this).find('input:text');
          for(var i = 0; i < divInputs.length; i++) {
            var inputValue = $(divInputs[i]).val().toLowerCase();
            if(inputValue.indexOf(searchVal) != -1) {
              return true;
            }
          }
          return false;
        }).show();
      } else {
        $('#addEntry, #saveYaml').prop('disabled', false);
        $('.entry-div').show();
      }
    });
  "))
  
  
  
)

# Define server
server <- function(input, output, session) {

  
  # Use a reactiveVal to monitor changes to the .config directory status
  config_dir_status <- reactiveVal(dir.exists(config_dir))
  
  # 2. Check for ~/.config directory
  observe({
    if (!config_dir_status()) {
      showModal(modalDialog(
        title = "Directory Not Found",
        "The .config directory does not exist. Would you like to create it?",
        footer = tagList(
          actionButton("create_config_dir", "Yes"),
          modalButton("No")
        )
      ))
    }
  })
  
  observeEvent(input$create_config_dir, {
    dir.create(config_dir)
    config_dir_status(TRUE)  # Update the status after creating the directory
    removeModal()
  })
  
  # Check for .shrtcts.yaml file
  observe({
    if (config_dir_status() && !file.exists(yaml_file)) {  # Only check for file if directory exists
      showModal(modalDialog(
        title = "File Not Found",
        ".shrtcts.yaml file does not exist in .config directory. Would you like to create it?",
        footer = tagList(
          actionButton("create_yaml_file", "Yes"),
          modalButton("No")
        )
      ))
    }
  })
  
  observeEvent(input$create_yaml_file, {
    # Here you can prepopulate the YAML file if necessary.
    file.create(yaml_file)
    removeModal()
  })
  
  
    entries <- reactiveVal(list())
  
  observe({
    if (file.exists(yaml_file)) {
      entries(yaml.load_file(yaml_file))
    }
  })
  
  observe({
    if (file.exists("readme.txt")) {
      readmeContent <- readLines("readme.txt")
      updateTextAreaInput(session, "readme", value = paste(readmeContent, collapse = "\n"))
    }
  })
  
  observe({
    entryList <- entries()
    output$entries <- renderUI({
      lapply(seq_along(entryList), function(i) {
        entry <- entryList[[i]]
        entryBinding <- paste(gsub("\"", "'", entry$Binding), collapse = "\n")
        leftwrap <- unlist(strsplit(entryBinding, "'"))[2]
        rightwrap <- unlist(strsplit(entryBinding, "'"))[4]
        
        div(
          class = "entry-div", # Add class to entry div
          id = paste0("div_", i),
          style = "background-color: #F0F0F0; padding: 10px; margin-bottom: 10px;",
          textInput(paste0("fieldA_", i), "Name:", value = entry$Name),
          textInput(paste0("fieldB_", i), "Description:", value = entry$Description),
          fluidRow(
            column(5, textInput(paste0("fieldC_leftwrap_", i), "leftwrap:", value = leftwrap)),
            column(2, "object", style = "padding-top: 25px; text-align: center;"),
            column(5, textInput(paste0("fieldC_rightwrap_", i), "rightwrap:", value = rightwrap))
          ),
          textInput(paste0("fieldD_", i), "Shortcut:", value = entry$shortcut),
          #checkboxInput(paste0("fieldE_", i), "Interactive:", value = entry$Interactive),
          actionButton(paste0("remove_", i), "Remove"),
          actionButton(paste0("moveup_", i), "Move Up"),
          actionButton(paste0("movedown_", i), "Move Down")
        )
      })
    })
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  # Move Up Logic
  observeEvent(lapply(1:100, function(i) input[[paste0("moveup_", i)]]), {
    for (i in 1:100) {
      if (!is.null(input[[paste0("moveup_", i)]]) && input[[paste0("moveup_", i)]] > 0) {
        current_entries <- entries()
        if (i > 1) {  # Check if it's not the first entry
          current_entries[c(i-1, i)] <- current_entries[c(i, i-1)]
          entries(current_entries)
        }
        return()
      }
    }
  }, ignoreInit = TRUE)
  
  # Move Down Logic
  observeEvent(lapply(1:100, function(i) input[[paste0("movedown_", i)]]), {
    for (i in 1:100) {
      if (!is.null(input[[paste0("movedown_", i)]]) && input[[paste0("movedown_", i)]] > 0) {
        current_entries <- entries()
        if (i < length(current_entries)) {  # Check if it's not the last entry
          current_entries[c(i, i+1)] <- current_entries[c(i+1, i)]
          entries(current_entries)
        }
        return()
      }
    }
  }, ignoreInit = TRUE)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  observeEvent(lapply(1:100, function(i) input[[paste0("remove_", i)]]), {  # Here, I've chosen 100 just as an upper limit. This assumes you'll not have more than 100 entries.
    # Loop through all remove buttons to find the one that triggered this event
    for (i in 1:100) {
      if (!is.null(input[[paste0("remove_", i)]]) && input[[paste0("remove_", i)]] > 0) {
        # Adjust the entries list
        current_entries <- entries()
        current_entries <- current_entries[-i]  # Remove the i-th entry
        entries(current_entries)  # Update the entries reactive value
        return()  # Exit the loop once the button is found and processed
      }
    }
  }, ignoreInit = TRUE)
  
  observeEvent(input$addEntry, {
    newEntry <- list(
      Name = "",
      Description = "",
      Binding = "",
      shortcut = "",
      Interactive = FALSE
    )
    entries(c(list(newEntry), entries()))
  })
  
  

  
  
  observeEvent(input$saveYaml, {
    entryList <- entries()
    entriesToSave <- lapply(seq_along(entryList), function(i) {
      entryName <- input[[paste0("fieldA_", i)]]
      if (entryName == "") return(NULL)
      
      entryBinding <- sprintf(
        "%s <- function(x){\n    context <- rstudioapi::getActiveDocumentContext()\n    id <- context$id\n    slct <- context$selection\n    rstudioapi::insertText(text =  paste('%s', slct[[1]]$text ,'%s' ,sep='')  )\n    }\n    %s()",
        entryName,
        input[[paste0("fieldC_leftwrap_", i)]],
        input[[paste0("fieldC_rightwrap_", i)]],
        entryName
      )
      
      list(
        Name = entryName,
        Description = sprintf("%s function", entryName),
        Binding = entryBinding,
        shortcut = input[[paste0("fieldD_", i)]],
        Interactive = as.logical(input[[paste0("fieldE_", i)]]) 
      )
    })
    
    entriesToSave <- Filter(Negate(is.null), entriesToSave)
    yamlContent <- as.character(yaml::as.yaml(entriesToSave))
    
    # Adjust formatting
    yamlContent <- gsub("  Binding: \"", "  Binding: |\n    ", yamlContent, fixed = TRUE)
    yamlContent <- gsub("\"", "", yamlContent, fixed = TRUE)
    yamlContent <- gsub("\\|\n    ", "|\n    ", yamlContent)  # Four spaces for line 4
    yamlContent <- gsub("\n        ", "\n    ", yamlContent) # Adjust the whitespace for lines 5 to 10 to four spaces
    yamlContent <- gsub("\n    ", "\n   ", yamlContent)      # Adjust the whitespace for lines 5 to 10 to three spaces
    yamlContent <- gsub("Interactive: \\[\\]", "Interactive: no\n", yamlContent) # Add an additional newline after Interactive field
    yamlContent <- sub("Binding: \\|-", "Binding: |-", yamlContent )
    
    writeLines(yamlContent, yaml_file)
  })
  
 
 
  
  
  
  
  
}

shinyApp(ui, server)
