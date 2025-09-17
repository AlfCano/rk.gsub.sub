// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!

function preview(){
	
    // Load GUI values (same as in js_calc)
    var func = getValue("func_dropdown");
    var use_na_pattern = getValue("na_pattern_cbox");
    var pattern = getValue("pattern_input");
    var use_na = getValue("na_cbox");
    var replacement = getValue("replacement_input");
    var x_vector = getValue("x_varslot");
    var ignore_case = getValue("ignorecase_cbox");
    var use_perl = getValue("perl_cbox");
    var is_fixed = getValue("fixed_cbox");
    var use_bytes = getValue("usebytes_cbox");
    var convert_to_factor = getValue("as_factor_cbox");

    // Build R command arguments (same as in js_calc)
    var rOptions = [];
    if (use_na_pattern == "1") {
      rOptions.push("pattern=NA");
    } else {
      rOptions.push("pattern=\"" + pattern + "\"");
    }
    if (use_na == "1") {
      rOptions.push("replacement=NA");
    } else {
      rOptions.push("replacement=\"" + replacement + "\"");
    }
    rOptions.push("x=" + x_vector);
    if (ignore_case == "1") { rOptions.push("ignore.case=TRUE"); }
    if (use_perl == "1") { rOptions.push("perl=TRUE"); }
    if (is_fixed == "1") { rOptions.push("fixed=TRUE"); }
    if (use_bytes == "1") { rOptions.push("useBytes=TRUE"); }

    // For the preview, first save result to a temporary vector
    var command = "preview_vector <- " + func + "(\n  " + rOptions.join(",\n  ") + "\n)\n";
    echo(command);

    // Conditionally convert the temporary vector to a factor
    if (convert_to_factor == "1") {
      echo("preview_vector <- as.factor(preview_vector)\n");
    }

    // Finally, create the special "preview_data" data.frame that RKWard expects
    echo("preview_data <- data.frame(replaced_vector=preview_vector)\n");
  
}

function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    // Load GUI values
    var func = getValue("func_dropdown");
    var use_na_pattern = getValue("na_pattern_cbox");
    var pattern = getValue("pattern_input");
    var use_na = getValue("na_cbox");
    var replacement = getValue("replacement_input");
    var x_vector = getValue("x_varslot");
    var ignore_case = getValue("ignorecase_cbox");
    var use_perl = getValue("perl_cbox");
    var is_fixed = getValue("fixed_cbox");
    var use_bytes = getValue("usebytes_cbox");
    var convert_to_factor = getValue("as_factor_cbox");
    var save_name = getValue("save_obj.objectname");

    // Build R command arguments
    var rOptions = [];
    if (use_na_pattern == "1") {
      rOptions.push("pattern=NA");
    } else {
      rOptions.push("pattern=\"" + pattern + "\"");
    }
    if (use_na == "1") {
      rOptions.push("replacement=NA");
    } else {
      rOptions.push("replacement=\"" + replacement + "\"");
    }
    rOptions.push("x=" + x_vector);
    if (ignore_case == "1") { rOptions.push("ignore.case=TRUE"); }
    if (use_perl == "1") { rOptions.push("perl=TRUE"); }
    if (is_fixed == "1") { rOptions.push("fixed=TRUE"); }
    if (use_bytes == "1") { rOptions.push("useBytes=TRUE"); }

    // Assemble and print the final R command
    var command = "replaced.vector <- " + func + "(\n  " + rOptions.join(",\n  ") + "\n)\n";
    echo(command);

    if (convert_to_factor == "1") {
      echo("replaced.vector <- as.factor(replaced.vector)\n");
    }
  
}

function printout(is_preview){
	// read in variables from dialog


	// printout the results
	if(!is_preview) {
		new Header(i18n("Pattern Replacement (sub/gsub) results")).print();	
	}{
        var header_cmd = "rk.header(\"Pattern replacement results saved to object: " + getValue("save_obj.objectname") + "\", level=3);\n";
        echo(header_cmd);
    }
  
	if(!is_preview) {
		//// save result object
		// read in saveobject variables
		var saveObj = getValue("save_obj");
		var saveObjActive = getValue("save_obj.active");
		var saveObjParent = getValue("save_obj.parent");
		// assign object to chosen environment
		if(saveObjActive) {
			echo(".GlobalEnv$" + saveObj + " <- replaced.vector\n");
		}	
	}

}

