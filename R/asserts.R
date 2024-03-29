escape_symbols <- function(s) {
  for (kk in seq_along(s)) {
    ch <- s[kk]
    if (grepl("^[[:space:]]$", ch)) {
      ch <- gsub('(^"|"$)', "", deparse(ch))
      s[kk] <- ch;
    }
  }
  s
}

assert_valid_alphabet <- function(alphabet) {
  stopifnot(length(alphabet) > 0, is.character(alphabet), !anyNA(alphabet), all(nchar(alphabet) == 1))
  
  ## Allow only for 0-9, A-Z, a-Z, '-', ';'
  unknown <- setdiff(alphabet, c(0:9, LETTERS, letters, "-", ";"))
  if (length(unknown) > 0) {
    unknown <- escape_symbols(unique(sort(unknown)))
    stop(sprintf("Non-supported symbols in alphabet: [n=%d] %s", length(unknown), paste(sQuote(unknown), collapse = ", ")))
  }  
}  

assert_in_alphabet <- function(seq, alphabet) {
  stopifnot(length(seq) == 1, is.character(seq), !is.na(seq))
  assert_valid_alphabet(alphabet)

  ## Nothing to do?
  if (nchar(seq) == 0) {
    return(seq)
  }

  seq <- strsplit(seq, split = "", fixed = TRUE)[[1]]
  unknown <- setdiff(seq, alphabet)
  if (length(unknown) > 0) {
    unknown <- escape_symbols(unique(sort(unknown)))
    stop(sprintf("Sequence symbols not in alphabet: [n=%d] %s (not in %s)", length(unknown), paste(sQuote(unknown), collapse = ", "), paste(sQuote(escape_symbols(alphabet)), collapse = ", ")))
  }
}

assert_alphabet <- function(alphabet) {
  stopifnot(is.character(alphabet), !anyNA(alphabet), is.character(names(alphabet)))

#  ## Assert unique letters (only for bijective alphabets)
#  dups <- names(alphabet)[duplicated(names(alphabet))]
#  if (length(dups) > 0) {
#    dups <- paste(dups, collapse = " ")
#    stop(sprintf("Detected duplicated names (%s) in 'alphabet'", dups))
#  }
  
  if (all(nchar(alphabet) == 0)) {
    return()
  }

  unknown <- setdiff(alphabet, names(alphabet))
  if (length(unknown) > 0) {
    missing <- paste(unknown, collapse = " ")
    stop(sprintf("Detected values (%s) in 'alphabet' that are not in the names", missing))
  }
}

assert_complementary <- function(watson, crick, alphabet) {
  alphabet <- get_alphabet(alphabet)

  ## Validate 'alphabet':
  assert_alphabet(alphabet)

  if (!"-" %in% names(alphabet)) {
    alphabet <- c(alphabet, "-" = "-")
  }

  ## Validate 'watson' and 'crick':
  stopifnot(nchar(watson) == nchar(crick))
  assert_in_alphabet(watson, alphabet = names(alphabet))
  assert_in_alphabet(crick, alphabet = names(alphabet))

  watson <- strsplit(watson, split = "", fixed = TRUE)[[1]]
  crick <- rev(strsplit(crick, split = "", fixed = TRUE)[[1]])
  for (kk in seq_along(watson)) {
    if (watson[kk] == "-" || crick[kk] == "-")
      next
    if (!crick[kk] %in% alphabet[names(alphabet) == watson[kk]]) {
      stop(sprintf("Non-complementary basepair (%s,%s) detected at position %d", watson[kk], crick[kk], kk))
    }
  }
  
  invisible(TRUE)
}


assert_checksum <- function(checksum, prefix = "") {
  stopifnot(length(checksum) == 1L, !is.na(checksum))
  if (nzchar(prefix)) {
    pattern <- "^(|(l|c)(s|d))seguid="
    stopifnot(grepl(pattern, checksum))
    checksum <- sub(pattern, "", checksum)
  }
  stopifnot(nchar(checksum) == 27)
}
