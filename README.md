[![seguid status badge](https://seguid.r-universe.dev/badges/seguid)](https://seguid.r-universe.dev/seguid)
[![R checks](https://github.com/seguid/seguid-r/actions/workflows/check-r.yml/badge.svg)](https://github.com/seguid/seguid-r/actions/workflows/check-r.yml)
[![CLI checks](https://github.com/seguid/seguid-r/actions/workflows/check-cli.yml/badge.svg)](https://github.com/seguid/seguid-r/actions/workflows/check-cli.yml)
[![Test coverage](https://codecov.io/gh/seguid/seguid-r/branch/main/graph/badge.svg)](https://app.codecov.io/gh/seguid/seguid-r)


# SEGUID v2: Checksums for Linear, Circular, Single- and Double-Stranded Biological Sequences

This R package, **seguid**, implements SEGUID v2 together with the
original SEGUID algorithm.


## Examples

### Single-stranded DNA

```r
> library(seguid)

## Linear single-stranded DNA
> lsseguid("TATGCCAA")
[1] "lsseguid=EevrucUNYjqlsxrTEK8JJxPYllk"

## Linear single-stranded DNA
> lsseguid("AATATGCC")
[1] "lsseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw"

## Circular single-stranded DNA
> csseguid("TATGCCAA")
[1] "csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw"

## Same rotating two basepairs
> csseguid("GCCAATAT")
[1] "csseguid=XsJzXMxgv7sbpqIzFH9dgrHUpWw"
```


### Double-stranded DNA

```r
> library(seguid)

## Linear double-stranded DNA
> ldseguid("AATATGCC", "GGCATATT")
[1] "cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A"

## Same swapping Watson and Crick 
> ldseguid("GGCATATT", "AATATGCC")
[1] "cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A"

## Circular double-stranded DNA
> cdseguid("TATGCCAA", "TTGGCATA")
[1] "cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A"

## Same swapping Watson and Crick 
> cdseguid("TTGGCATA", "TATGCCAA")
[1] "cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A"

## Same rotating two basepairs (= minimal rotation by Watson)
> cdseguid("AATATGCC", "GGCATATT")
[1] "cdseguid=dUxN7YQyVInv3oDcvz8ByupL44A"
```
