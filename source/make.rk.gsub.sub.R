local({
  # Golden Rule 1: Single script wrapped in local()
require(rkwarddev)
  # Define plugin metadata (Golden Rule 5)
  about.info <- rk.XML.about(
    name = "rk.gsub.sub",
    author = person(
      given = "Alfonso",
      family = "Cano Robles",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "RKWard GUI for sub() and gsub() to find and replace patterns in character vectors.",
      version = "0.0.7",
      url = "https://github.com/AlfCano/rk.gsub.sub"
    )
  )

  # Golden Rule 2: Define and assemble the help file
  plugin_help_list <- list(
    title = "Pattern Replacement (sub/gsub)",
    summary = "This plugin provides a graphical interface for the base R functions sub() and gsub(), which perform pattern replacement in character vectors.",
    usage = "Select the function (sub or gsub), specify the pattern to find and the text to replace it with. Choose a character vector from a data frame as the input. Adjust options for case sensitivity, PERL compatibility, fixed matching, and byte-wise operation.",
    sections = list(
      "Function" = "Choose between 'sub' (replaces only the first occurrence of the pattern in each string) and 'gsub' (replaces all occurrences).",
      "Pattern" = "The regular expression or fixed string to search for. Check 'Use NA as pattern' to find existing NA values.",
      "Replacement" = "The text to replace the found pattern with. Check 'Use NA as replacement' to insert NA instead of a string.",
      "Input Vector (x)" = "Select a data frame and then the character vector column to perform the replacements on.",
      "Options" = "Control the matching behavior: 'ignore.case', 'perl' compatible regex, 'fixed' string matching (disables regex), and 'useBytes' for byte-by-byte matching.",
      "Save Object" = "The results of the operation are saved to a new object in the R workspace. You can also choose to convert the final vector to a factor."
    )
  )
  help_doc <- rk.rkh.doc(
    title = rk.rkh.title(text = plugin_help_list$title),
    summary = rk.rkh.summary(plugin_help_list$summary),
    usage = rk.rkh.usage(plugin_help_list$usage),
    sections = lapply(names(plugin_help_list$sections), function(title) {
      rk.rkh.section(title, plugin_help_list$sections[[title]])
    })
  )

  ## UI components
  var_selector <- rk.XML.varselector(id.name = "main_var_selector")
  x_varslot <- rk.XML.varslot(
    label = "Input character vector (x)",
    source = "main_var_selector",
    classes = "character",
    required = TRUE,
    id.name = "x_varslot"
  )
  func_dropdown <- rk.XML.dropdown(
    label = "Function to use",
    options = list(
      "Global replacement (gsub)" = list(val = "gsub", chk = TRUE),
      "First replacement (sub)" = list(val = "sub")
    ),
    id.name = "func_dropdown"
  )
  na_pattern_cbox <- rk.XML.cbox(label = "Use NA as pattern", value = "1", id.name = "na_pattern_cbox")
  pattern_input <- rk.XML.input(label = "Pattern", id.name = "pattern_input")
  pattern_frame <- rk.XML.frame(na_pattern_cbox, pattern_input, label="Pattern")
  na_cbox <- rk.XML.cbox(label = "Use NA as replacement", value = "1", id.name = "na_cbox")
  replacement_input <- rk.XML.input(label = "Replacement", id.name = "replacement_input")
  replacement_frame <- rk.XML.frame(na_cbox, replacement_input, label = "Replacement")
  ignorecase_cbox <- rk.XML.cbox(label = "ignore.case", value = "1", id.name = "ignorecase_cbox")
  perl_cbox <- rk.XML.cbox(label = "perl", value = "1", id.name = "perl_cbox")
  fixed_cbox <- rk.XML.cbox(label = "fixed", chk = TRUE, value = "1", id.name = "fixed_cbox")
  usebytes_cbox <- rk.XML.cbox(label = "useBytes", value = "1", id.name = "usebytes_cbox")
  options_frame <- rk.XML.frame(
    ignorecase_cbox, perl_cbox, fixed_cbox, usebytes_cbox, label = "Options"
  )
  as_factor_cbox <- rk.XML.cbox(label = "Convert result to factor", value = "1", id.name = "as_factor_cbox")
  save_obj <- rk.XML.saveobj(
    label = "Save result to", initial = "replaced.vector", chk = TRUE, id.name = "save_obj"
  )

  # NEW: Preview button, as seen in the rk.cSplit example
  preview_button <- rk.XML.preview(mode = "data")

  # Assemble the dialog
  controls_col <- rk.XML.col(
    func_dropdown,
    pattern_frame,
    replacement_frame,
    x_varslot,
    options_frame,
    as_factor_cbox,
    save_obj,
    preview_button # ADDED to layout
  )
  dialog_content <- rk.XML.dialog(
    child = rk.XML.row(var_selector, controls_col),
    label = "Pattern Replacement"
  )

  ## JavaScript generation
  js_calc <- '
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
      rOptions.push("pattern=\\"" + pattern + "\\"");
    }
    if (use_na == "1") {
      rOptions.push("replacement=NA");
    } else {
      rOptions.push("replacement=\\"" + replacement + "\\"");
    }
    rOptions.push("x=" + x_vector);
    if (ignore_case == "1") { rOptions.push("ignore.case=TRUE"); }
    if (use_perl == "1") { rOptions.push("perl=TRUE"); }
    if (is_fixed == "1") { rOptions.push("fixed=TRUE"); }
    if (use_bytes == "1") { rOptions.push("useBytes=TRUE"); }

    // Assemble and print the final R command
    var command = "replaced.vector <- " + func + "(\\n  " + rOptions.join(",\\n  ") + "\\n)\\n";
    echo(command);

    if (convert_to_factor == "1") {
      echo("replaced.vector <- as.factor(replaced.vector)\\n");
    }
  '

  # NEW: JavaScript logic for the preview button
  js_gsub_preview <- '
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
      rOptions.push("pattern=\\"" + pattern + "\\"");
    }
    if (use_na == "1") {
      rOptions.push("replacement=NA");
    } else {
      rOptions.push("replacement=\\"" + replacement + "\\"");
    }
    rOptions.push("x=" + x_vector);
    if (ignore_case == "1") { rOptions.push("ignore.case=TRUE"); }
    if (use_perl == "1") { rOptions.push("perl=TRUE"); }
    if (is_fixed == "1") { rOptions.push("fixed=TRUE"); }
    if (use_bytes == "1") { rOptions.push("useBytes=TRUE"); }

    // For the preview, first save result to a temporary vector
    var command = "preview_vector <- " + func + "(\\n  " + rOptions.join(",\\n  ") + "\\n)\\n";
    echo(command);

    // Conditionally convert the temporary vector to a factor
    if (convert_to_factor == "1") {
      echo("preview_vector <- as.factor(preview_vector)\\n");
    }

    // Finally, create the special "preview_data" data.frame that RKWard expects
    echo("preview_data <- data.frame(replaced_vector=preview_vector)\\n");
  '

  js_print <- '{
        var header_cmd = "rk.header(\\"Pattern replacement results saved to object: " + getValue("save_obj.objectname") + "\\", level=3);\\n";
        echo(header_cmd);
    }
  '

  # Create the plugin skeleton
  rk.plugin.skeleton(
    about = about.info,
    path = ".",
    xml = list(dialog = dialog_content),
    # UPDATED: js list now includes the preview script
    js = list(
        calculate = js_calc,
        preview = js_gsub_preview,
        printout = js_print
    ),
    rkh = list(help = help_doc),
    pluginmap = list(
      name = "Pattern Replacement (sub/gsub)",
      hierarchy = list("data")
    ),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = TRUE
  )

  # Golden Rule 9: Provide final instructions to the user
  cat("\nPlugin files generated.\n\nTo complete the installation, please run the following commands in your R console:\n\n")
  cat("  # Installs or updates dependencies and message catalog\n")
  cat("  rk.updatePluginMessages(plugin.dir=\"rk.gsub.sub\")\n\n")
  cat("  # Install the plugin package\n")
  cat("  devtools::install(\"rk.gsub.sub\")\n")

})
