# RKWard Plugin: Pattern Replacement (sub/gsub) rk.gsub.sub

An RKWard plugin that provides a graphical user interface (GUI) for the base R functions `sub()` and `gsub()`. This tool allows users to perform powerful pattern finding and replacement on character vectors without needing to write code.

## Features

*   **Switch Functions:** Easily toggle between `gsub` (replace all occurrences) and `sub` (replace first occurrence).
*   **Flexible Inputs:** Use text strings or `NA` values for both the pattern to find and the replacement text.
*   **Full Regex Control:** Full control over key function arguments:
    *   `ignore.case`: For case-insensitive matching.
    *   `perl`: To use the powerful Perl-compatible regular expression engine.
    *   `fixed`: To treat the pattern as a literal string instead of a regex.
    *   `useBytes`: For byte-by-byte matching.
*   **Data Preview:** A live preview button shows the result of the replacement before committing.
*   **Type Conversion:** Optionally convert the final character vector into a factor.
*   **Save Output:** Save the resulting vector to a new object in the R workspace.

## Installation

To install this plugin, you will need R, RKWard, and the `devtools` and `rkwarddev` packages installed.


 **Install the Package:**
    Finally, install the plugin package using `devtools`:
    ```R
    local({
## Preparar
require(devtools)
## Computar
  install_github(
    repo="AlfCano/rk.gsub.sub"
  )
## Imprimir el resultado
rk.header ("Resultados de Instalar desde git")
})
    ```

 **Restart RKWard:**
    Close and reopen RKWard. The new plugin will be available in the top menu.

## How to Use

1.  After installation, find the plugin in the RKWard menu under **Data > Pattern Replacement (sub/gsub)**.
2.  On the left, select the data frame containing the vector you want to modify.
3.  In the main panel, select the target character or factor column from the **Input character vector (x)** dropdown.
4.  Fill in the **Pattern** and **Replacement** fields. Use the checkboxes if you want to find or replace with `NA`.
5.  Adjust the **Options** checkboxes (`ignore.case`, `perl`, `fixed`) to control the matching behavior.
6.  (Optional) Check **Convert result to factor** if you need a factor as output.
7.  Specify a name for the output object in the **Save result to** field.
8.  Click the **Preview** button to see a sample of the output.
9.  Click **Submit** to run the operation and create the new object.

## Examples

### Example 1: Cleaning Age Groups in the `esoph` Dataset

The `esoph` dataset has an `agegp` column with values like `"25-34"` and `"75+"`. Let's clean this to get just the numbers.

1.  Load the data in R: `data(esoph)`
2.  Open the plugin.
3.  Select `esoph` and the `agegp` column.
4.  Set the following options:
    *   **Function to use:** `Global replacement (gsub)`
    *   **Pattern:** `[+-]` (This regex matches a plus OR a hyphen)
    *   **Replacement:** (leave this field blank)
    *   **ignore.case:** Unchecked
    *   **perl:** Checked
    *   **fixed:** Unchecked
5.  Click **Submit**.

The resulting vector will contain values like `"2534"` and `"75"`.

### Example 2: Replacing `NA` Values

Imagine you have a vector with missing values that you want to label clearly.

1.  Create a test vector in R: `test_vec <- c("Red", "Blue", NA, "Green")`
2.  Open the plugin.
3.  Select `test_vec` as the input vector.
4.  Set the following options:
    *   **Pattern:** Check the **Use NA as pattern** box.
    *   **Replacement:** Type `Unknown` in the text field.
5.  Click **Submit**.

The resulting vector will be `[1] "Red" "Blue" "Unknown" "Green"`.

## Author

*   Alfonso Cano Robles
