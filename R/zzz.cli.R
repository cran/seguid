cli_help_string <- "
{{ package }}: Sequence Globally Unique Identifier Checksums for Linear, Circular, Single- and Double-Stranded Biological Sequences

Usage:
 Rscript -e seguid::seguid [options] <<< '<sequence>'

Options:  
 --help            Display the full help page with examples
 --version         Output version of this software
 --alphabet=<SET>  Set of symbols for the input sequence.

Predefined alphabets:
 '{DNA}'              Complementary DNA symbols (= 'AT,CG')
 '{DNA-extended}'     Extended DNA (= '{DNA},BV,DH,KM,SS,RY,WW,NN')
 '{RNA}'              Complementary RNA symbols (= 'AU,CG')
 '{RNA-extended}'     Extended DNA (= '{RNA},BV,DH,KM,SS,RY,WW,NN')
 '{protein}'          Amino-acid symbols (= 'A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,
                      T,V,W,Y')
 '{protein-extended}' Amino-acid symbols (= '{protein},O,U,B,J,Z,X')

Examples:
Rscript -e seguid::seguid --version
Rscript -e seguid::seguid --help

echo 'ACGT' | Rscript -e seguid::seguid --type=lsseguid
Rscript -e seguid::seguid --type=lsseguid <<< 'ACGT'
Rscript -e seguid::seguid --type=cdseguid <<< $'ACGT\\nTGCA' # two-line syntax
Rscript -e seguid::seguid --type=ldseguid <<< 'ACGT;ACGT'   # watson-crick syntax
Rscript -e seguid::seguid --type=ldseguid <<< $'-CGT\\nTGCA' # two-line syntax
Rscript -e seguid::seguid --type=ldseguid <<< '-CGT;ACGT'   # watson-crick syntax
Rscript -e seguid::seguid --type=lsseguid --alphabet='{RNA}' <<< 'ACGU'

Version: {{ version }}
Copyright: Henrik Bengtsson (2023-2024)
License: MIT
"

#' @importFrom utils capture.output file_test str
cli_call_fcn <- function(..., alphabet = "{DNA}", file = NULL, debug = FALSE, fcn) {
  if (is.character(fcn)) {
    fcn <- get(fcn, mode = "function", envir = getNamespace(.packageName), inherits = FALSE)
  }
  stopifnot(length(debug) == 1, is.logical(debug), !is.na(debug))

  alphabet2 <- get_alphabet(alphabet)
  
  seq <- NULL
  
  args <- list(...)
  nargs <- length(args)
  if (nargs > 0) {
    names <- names(args)
    if (is.null(names)) names <- rep("", times = nargs) 
    ## At most one unnamed CLI option
    unnamed <- which(nchar(names) == 0)
    n <- length(unnamed)
    if (n > 2) {
      unknown <- args[seq_len(n - 2)]
      stop("Unknown option(s): ", paste(sQuote(unknown), collapse = ", "))
    }
    if (n >= 1) {
      if (!is.null(file)) {
        stop("Option --file=<filename> already specified")
      }
      seq <- unlist(args[unnamed])
      seq <- paste(seq, collapse = "\n")
    }
  }

  if (is.null(seq)) {
    ## Get sequence input from file?
    if (!is.null(file)) {
      if (!file_test("-f", file)) {
        stop("No such file: ", sQuote(file))
      }
      seq <- readLines(file)
      seq <- paste(seq, collapse = "\n")
    } else {
      ## Get arguments from the standard input
      seq <- readLines("stdin")
      seq <- paste(seq, collapse = "\n")
    }
  }

  if (debug) {
    message(sprintf("Sequence data:\n%s", seq))
    message(sprintf("Arguments:\n%s", paste(capture.output(str(args)), collapse = "\n")))
  }

  ## Parse sequence string. This will throw an error if not meeting the minimal specifications
  argnames <- names(formals(fcn))
  if (is.element("crick", argnames)) {
    seq_spec <- parse_sequence_string(seq)
    args2 <- list(watson = seq_spec[["watson"]], crick = seq_spec[["crick"]])
    if (debug) {
      msg <- sprintf("Double-stranded sequence pair:\nwatson=%s\ncrick=%s", sQuote(args2[[1]]), sQuote(args2[[2]]))
    }
    if (debug) message(msg)
  } else {
    args2 <- list(seq)
  }
  args <- c(args2, args, alphabet = alphabet)
  if (debug) {
    message(sprintf("Arguments:\n%s", paste(capture.output(str(args)), collapse = "\n")))
  }

  res <- do.call(fcn, args = args)
  if (debug) {
    message(sprintf("Result:\n%s", paste(capture.output(str(res)), collapse = "\n")))
  }

  res <- paste(res, collapse = " ")
  cat(res, "\n", sep = "")
}


class(seguid) <- c("cli_function", class(seguid))
attr(seguid, "cli") <- function(..., type = c("seguid", "lsseguid", "csseguid", "ldseguid", "cdseguid")) {
  type <- match.arg(type)
  cli_call_fcn(..., fcn = type)
}
