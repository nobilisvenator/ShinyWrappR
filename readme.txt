OVERVIEW:
ShinyWrappR was made to enhance the RStudio code writing experience.  This Shiny app and the gadenbuie/shrtcts* package allow mapping of custom code to RStudio's keyboard shortcuts.  Additionally, your custom code will wrap around highlighted text/code in the editor pane.  Simply add your own entries to this Shiny app and run a few lines of code to reduce overall typing in Rstudio.

THINGS TO KNOW:
1. The grey boxes below contain: 
	* Row one - Text name.  This text is searchable from the Ctrl+F find function.
	* Row two - Description.  
	* Leftwrap/Righwrap fields - Custom text/code that will prefix/suffix (respectively) highlighted code in the editor pane
	  after pressing the associated keyboard combination.
	* Row four - Keyboard combination that will paste in the related custom code.

2. Use the Add Entry button to create a new custom code wrappr.

3. Pressing the keyboard combination on an empty line of the editor pane will still paste in the custom code wrappr.

4. Click the Save button in this app and then run the following in Rstudio to register the new changes, then close and re-launch RStudio.

	if (interactive() && requireNamespace('shrtcts', quietly = TRUE)){ 
	  shrtcts::add_rstudio_shortcuts(set_keyboard_shortcuts = TRUE) 
	}

5. Do not assign a keyboard shortcut that includes a number 0 to 9, use only alpha characters A to Z.

*Aden-Buie G (2022). shrtcts: Make Anything an RStudio Shortcut. https://pkg.garrickadenbuie.com/shrtcts, https://github.com/gadenbuie/shrtcts.




