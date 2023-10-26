






https://github.com/nobilisvenator/ShinyWrappR/assets/123887893/314d4a4d-b642-45e8-945e-f60c0899d248




OVERVIEW:
ShinyWrappR was made to enhance the RStudio code writing experience.  This Shiny app and the gadenbuie/shrtcts* package allow mapping of custom code to RStudio's keyboard shortcuts.  Additionally, your custom code will wrap around highlighted text/code in the editor pane.  Simply add your own entries to the ShinyWrappR app and run a few lines of code to reduce overall typing in Rstudio.

Getting Started:
1. Download from this repository and place the .shrtcts.yaml file in the .config folder (create if it does not exist) found in your home path directory (windows-> %userprofile%).  This file contains pre-made shortcuts.

2. RStudio requisites:
	* install.packages("devtools").
	* remotes::install_github("gadenbuie/shrtcts", force = TRUE).
 	* Run app.R or shiny::runGitHub(repo = "ShinyWrappR",username = "nobilisvenator").

3. Each yaml entry consists of: 
	* Row one - Text name.
	* Row two - Description.  
	* Leftwrap/Righwrap fields - Custom text/code that will prefix/suffix (respectively) 
 	  highlighted code in the editor pane after pressing the associated keyboard combination.
	* Row four - Keyboard combination that will paste in the related custom code.
 	  Do not assign a keyboard shortcut that includes a number 0 to 9.  Use only alpha
    	  characters A to Z and function keys (Shift, Alt, Ctrl).

4. In the ShinyWrappR app, use the Add Entry button to create a new custom code and assigned key combination.

5. Additionally use the remove button to delete an entry, and the move up/down buttons to change the order.

6. Click the Save button in this app and then run the following in Rstudio to register the new changes, then close and re-launch RStudio.

	if (interactive() && requireNamespace('shrtcts', quietly = TRUE)){ 
	  shrtcts::add_rstudio_shortcuts(set_keyboard_shortcuts = TRUE) 
	}

7. Highlight an object, code, or multiple lines, press a desired key combination and save some typing!

*Aden-Buie G (2022). shrtcts: Make Anything an RStudio Shortcut. https://pkg.garrickadenbuie.com/shrtcts, https://github.com/gadenbuie/shrtcts.





