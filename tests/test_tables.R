get_alphabet <- seguid:::get_alphabet
make_alphabet <- seguid:::make_alphabet

alphabet <- get_alphabet("{DNA}")
stopifnot(length(alphabet) == 4L)

alphabet <- get_alphabet("{RNA}")
stopifnot(length(alphabet) == 4L)

alphabet <- get_alphabet("{DNA-extended}")
stopifnot(length(alphabet) == 15L)

alphabet <- get_alphabet("{RNA-extended}")
stopifnot(length(alphabet) == 15L)

alphabet <- get_alphabet("{protein}")
stopifnot(length(alphabet) == 22L)

alphabet <- get_alphabet("{protein-extended}")
stopifnot(length(alphabet) == 26L)

## Unknown alphabet
res <- tryCatch({
  alphabet <- get_alphabet("unknown")
}, error = identity)
stopifnot(inherits(res, "error"))


truth <- get_alphabet("{DNA}")
alphabet <- make_alphabet("CG,AT")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{RNA}")
alphabet <- make_alphabet("CG,AU")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{protein}")
alphabet <- make_alphabet("A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y,O,U")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{DNA-extended}")
alphabet <- make_alphabet("CG,AT,WW,SS,MK,RY,BV,DH,VB,NN")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{RNA-extended}")
alphabet <- make_alphabet("CG,AU,WW,SS,MK,RY,BV,DH,VB,NN")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{protein-extended}")
alphabet <- make_alphabet("A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y,O,U,B,J,Z,X")
stopifnot(identical(sort(alphabet), sort(truth)))

## Invalid components; should be either one or two characters
res <- tryCatch({
  alphabet <- make_alphabet("ATT")
}, error = identity)
stopifnot(inherits(res, "error"))

## Incompatible components
res <- tryCatch({
  alphabet <- make_alphabet("AT,T")
}, error = identity)
stopifnot(inherits(res, "error"))

truth <- c(get_alphabet("{DNA}"), a = "u", u = "a")
alphabet <- get_alphabet("{DNA},au,ua")
stopifnot(identical(sort(alphabet), sort(truth)))
